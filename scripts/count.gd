extends CharacterBody2D

var id := 0
var imposter := false

enum State {ROAM, DEAD} #Not sure if this is what to do for the movement stuff
var current_state = State.ROAM

@onready var murder_zone: Area2D = $MurderZone
@onready var murder_collision_shape_2d: CollisionShape2D = $MurderZone/CollisionShape2D
@onready var murder_clock: Timer = $MurderClock
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if imposter:
		murder_collision_shape_2d.disabled = false
		murder_clock.start()
		sprite_2d.texture = load("res://assets/Temp_Imposta.png")
	pass

#I believe this is where the roaming function would be, need to research that more though
#Maybe if you're the imposter, you should try to roam to other NPCs/Have different roaming mechanics in general
func _process(delta: float) -> void:
	pass

#This is the killing mechanic, need to check whether or not the Count is an imposter for what it does, currently just queue_free but later it should play a sound and animation 
# and maybe just set the NPC state to being dead
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		queue_free()
	pass # Replace with function body.

#Here I would need to play the murder audio, and also the character murdered needs to play a death animation
func _on_murder_clock_timeout() -> void:
	var possible_victims: Array = []
	
	for body in murder_zone.get_overlapping_bodies():
		if body != self and body.current_state != State.DEAD:
			possible_victims.append(body)
			
	if possible_victims.is_empty():
		print("no one to murder")
		return
		
	var victim = possible_victims.pick_random()
	victim.current_state = State.DEAD
	victim.queue_free() #play an animation instead
	print("Killed NPC", victim.id)
