extends CharacterBody2D

var id := 0
var imposter := false

enum State {ROAM, DEAD} #Not sure if this is what to do for the movement stuff
var current_state = State.ROAM
#This litterally should be a walking around function, maybe i can complicate it more later on with stuff like a panic mechanic
#Also the player should be able to click to kill a count; 
#my imposter mechanics might honestly be a boolean in the count scene
# if its true then it would enable the vision cone and other imposter features
# currently I plan for an imposter to look exactly the same as a count


@onready var murder_collision_shape_2d: CollisionShape2D = $MurderZone/CollisionShape2D
@onready var murder_clock: Timer = $MurderClock

func _ready() -> void:
	if imposter:
		murder_collision_shape_2d.disabled = false
		murder_clock.start()
	pass

#I believe this is where the roaming function would be, need to research that more though
func _process(delta: float) -> void:
	pass

#This is the killing mechanic, need to check whether or not the Count is an imposter for what it does, currently just queue_free but later it should play a sound and animation 
# and maybe just set the NPC state to being dead
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		queue_free()
	pass # Replace with function body.

#Here I would check the NPCs in the MurderZone and murder one of them, idk how though...
func _on_murder_clock_timeout() -> void:
	if current_state != State.DEAD:
		print("You're DEAD")
	pass # Replace with function body.
