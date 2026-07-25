extends CharacterBody2D

@onready var murder_zone: Area2D = $MurderZone
@onready var murder_collision_shape_2d: CollisionShape2D = $MurderZone/CollisionShape2D
@onready var murder_clock: Timer = $MurderClock
@onready var wait_timer: Timer = $WaitTimer

@onready var body: Sprite2D = $Sprite2D
@onready var hat: Sprite2D = $Sprite2D2
@onready var robe: Sprite2D = $Sprite2D3

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

func _ready() -> void:
	if imposter:
		murder_collision_shape_2d.disabled = false
		murder_clock.start()
		body.texture = load("res://assets/Temp_Imposta.png")
		
	body_default_y = body.position.y
	hat_default_y = hat.position.y
	robe_default_y = robe.position.y
	
	pick_new_target()
	
#Maybe if you're the imposter, you should try to roam to other NPCs/Have different roaming mechanics in general
func _process(delta: float) -> void:
	if current_state == State.DEAD:
		body.texture = load("res://assets/Temp_Imposta.png")
		velocity = Vector2.ZERO
		
		if not died:
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
	
#This is the killing mechanic, need to check whether or not the Count is an imposter for what it does, currently just queue_free but later it should play a sound and animation 
# and maybe just set the NPC state to being dead
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		queue_free()

#Here I would need to play the murder audio, and also the character murdered needs to play a death animation
func _on_murder_clock_timeout() -> void:
	var possible_victims: Array = []
	
	for body in murder_zone.get_overlapping_bodies():
		if body is CharacterBody2D and not body.imposter and body.current_state != State.DEAD:
			possible_victims.append(body)
			
	if possible_victims.is_empty():
		print("no one to murder")
		return
		
	var victim = possible_victims.pick_random()
	victim.current_state = State.DEAD
	#victim.queue_free() #play an animation instead
	print("Killed NPC", victim.id)


func _on_wait_timer_timeout() -> void:
	if not died:
		current_state = State.ROAM
		wait_timer.wait_time = randf_range(0.5, 2)
		pick_new_target()
