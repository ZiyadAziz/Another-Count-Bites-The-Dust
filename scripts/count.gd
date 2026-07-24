extends CharacterBody2D

var id := 0
var imposter := false
#This litterally should be a walking around function, maybe i can complicate it more later on with stuff like a panic mechanic
#Also the player should be able to click to kill a count; 
#my imposter mechanics might honestly be a boolean in the count scene
# if its true then it would enable the vision cone and other imposter features
# currently I plan for an imposter to look exactly the same as a count


@onready var murder_collision_shape_2d: CollisionShape2D = $MurderZone/CollisionShape2D

func _ready() -> void:
	if imposter:
		murder_collision_shape_2d.disabled = false
	pass
