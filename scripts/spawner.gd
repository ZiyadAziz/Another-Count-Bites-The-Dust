extends Area2D

@export var count_to_spawn: PackedScene 
@onready var game = get_node("/root/Game")
@onready var level_manager: Node = %LevelManager

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var spawn_id := 1

func _ready() -> void:
	spawn_count()
	pass


func spawn_count() -> void:
	while level_manager.count_count < level_manager.max_count:
		##LOOK MORE INTO HOW THESE LINES OF CODE WORKS, FOR KNOWLEDGE SAKE
		var shape = collision_shape_2d.shape as RectangleShape2D
		var size = shape.extents
		var origin = collision_shape_2d.global_position
		
		var random_x = randf_range(origin.x - size.x, origin.x + size.x)
		var random_y = randf_range(origin.y - size.y, origin.y + size.y)
	
		var count = count_to_spawn.instantiate()
		count.global_position = Vector2(random_x, random_y)
		count.id = spawn_id 
		if spawn_id <= level_manager.imposter_count:
			count.imposter = true
		
		get_parent().call_deferred("add_child", count)
		
		level_manager.count_spawned()
		spawn_id += 1
