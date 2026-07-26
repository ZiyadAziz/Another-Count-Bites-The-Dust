extends CharacterBody2D

@onready var murder_zone: Area2D = $MurderZone
@onready var murder_collision_shape_2d: CollisionShape2D = $MurderZone/CollisionShape2D
@onready var murder_clock: Timer = $MurderClock
@onready var wait_timer: Timer = $WaitTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var body: Sprite2D = $Sprite2D
@onready var hat: Sprite2D = $Sprite2D2
@onready var robe: Sprite2D = $Sprite2D3

@onready var level_manager = get_node("/root/Game/LevelManager")

var id := 0
var imposter := false

enum State {ROAM, WAIT, DEAD}
var current_state = State.ROAM
var died = false

const SPEED := 40.0
const ROAM_AREA := 100.0
const TARGET_THRESHOLD := 6.0

var roam_target := Vector2.ZERO
var move_direction := Vector2.ZERO

const BOB_SPEED := 16.0
const BOB_AMOUNT := 2.5
var bob_timer := 0.0

var body_default_y := 0.0
var hat_default_y := 0.0
var robe_default_y := 0.0

@onready var death: AudioStreamPlayer = $Death
@onready var player_kill: AudioStreamPlayer = $PlayerKill

#blonde, dark brown, gray, pink
var bodyPaths: Array[String] = ["res://assets/body_bd.png", "res://assets/body_db.png", "res://assets/body_g.png", "res://assets/body_p.png"]

#black, gold, rose, red, silver
var hatPaths: Array[String] = ["res://assets/hat_b.png", "res://assets/hat_g.png", "res://assets/hat_r.png", "res://assets/hat_red.png", "res://assets/hat_s.png"]

#blue, dark green, gray, pink, red
var robePaths: Array[String] = ["res://assets/robe_b.png", "res://assets/robe_dg.png", "res://assets/robe_gr.png", "res://assets/robe_p.png", "res://assets/robe_r.png"]

func _ready() -> void:
	var robeIndex = id % len(robePaths)
	var hatIndex = ((id - 1) / 5) % 5
	var bodyIndex = int(ceil(float(id) / (len(robePaths) * len(hatPaths)))) - 1
	
	body.texture = load(bodyPaths[bodyIndex])
	hat.texture = load(hatPaths[hatIndex])
	robe.texture = load(robePaths[robeIndex])
	if imposter:
		murder_collision_shape_2d.disabled = false
		murder_clock.wait_time = GameStats.murder_time
		if GameStats.current_difficulty == GameStats.Difficulty.TUTORIAL:
			body.texture = load("res://assets/Temp_Imposta.png")
			hat.texture = load("res://assets/imposter.png")
			robe.texture = load("res://assets/Temp_Imposta.png")
			pass 
		murder_clock.start()
		
	body_default_y = body.position.y
	hat_default_y = hat.position.y
	robe_default_y = robe.position.y
	
	pick_new_target()
	
#Maybe if you're the imposter, you should try to roam to other NPCs/Have different roaming mechanics in general
func _process(delta: float) -> void:
	if current_state == State.DEAD:
		velocity = Vector2.ZERO
		
		if not died:
			if imposter:
				level_manager.imposter_killed()
			elif not imposter:
				level_manager.count_killed()
			collision_shape_2d.disabled = true
			self.input_pickable = false
			self.z_index = 0
			death.pitch_scale = randf_range(0.95, 1.1)
			death.play()
			create_tween().tween_property(self, "rotation_degrees", 90.0, 0.3)
			
		died = true
		return
		
	if current_state == State.WAIT:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if current_state == State.ROAM:
		var to_target = roam_target - global_position
		if to_target.length() < TARGET_THRESHOLD:
			current_state = State.WAIT
			wait_timer.start()
			return
		
		velocity = move_direction * SPEED
		move_and_slide()
		
		#bounce off of other npcs and wall
		if get_slide_collision_count() > 0:
			var collision = get_slide_collision(0)
			
			move_direction = move_direction.bounce(collision.get_normal()).normalized()
			
			roam_target = global_position + move_direction * ROAM_AREA
		
		#flips the assets based on what direction the Count is facing
		if move_direction.x != 0:
			var facing_left = move_direction.x < 0
			body.flip_h = facing_left
			hat.flip_h = facing_left
			robe.flip_h = facing_left
			
		#Bobbing while moving 
		bob_timer += delta * BOB_SPEED
		var offset = sin(bob_timer) * BOB_AMOUNT
		
		body.position.y = body_default_y + offset
		hat.position.y = hat_default_y + offset
		robe.position.y = robe_default_y + offset

func pick_new_target():
	var angle = randf() * TAU
	var distance = randf_range(40.0, ROAM_AREA) 
	
	roam_target = global_position + Vector2.RIGHT.rotated(angle) * distance
	move_direction = (roam_target - global_position).normalized()
	
func pick_new_target_run(runaway: float):
	var angle = randf() * TAU
	var distance = randf_range(runaway, 1000) 
	
	roam_target = global_position + Vector2.RIGHT.rotated(angle) * distance
	move_direction = (roam_target - global_position).normalized()
	
#This is the killing mechanic, need to check whether or not the Count is an imposter for what it does, currently just queue_free but later it should play a sound and animation 
# and maybe just set the NPC state to being dead
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not imposter:
			level_manager.incorrect_guess()
		elif imposter:
			level_manager.assassin_assassinated()
		player_kill.play()
		current_state = State.DEAD
		print("Killed NPC", id)

#Here I would need to play the murder audio, and also the character murdered needs to play a death animation
func _on_murder_clock_timeout() -> void:
	if not died:
		var possible_victims: Array = []
		
		for NPC in murder_zone.get_overlapping_bodies():
			if NPC is CharacterBody2D and not NPC.imposter and NPC.current_state != State.DEAD:
				possible_victims.append(NPC)
				
		if possible_victims.is_empty():
			print("no one to murder")
			return
			
		var victim = possible_victims.pick_random()
		victim.current_state = State.DEAD
		
		#There could be an issue where 2 assassins murder the same target, so count_assassinated goes up by 2 even though only 1 was murdered
		#Hopefully this fixes that issue
		if not victim.died: 
			level_manager.count_assassinated() 
			
		pick_new_target_run(ROAM_AREA)


func _on_wait_timer_timeout() -> void:
	if not died:
		current_state = State.ROAM
		wait_timer.wait_time = randf_range(0.5, 2)
		pick_new_target()
