extends Area2D

@export var count_to_spawn: PackedScene 
@onready var game = get_node("/root/Game")
@onready var level_manager: Node = %LevelManager

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var spawn_id := 1
var imposter_ID: Array = []
var imposter_subset: Array = []

func _ready() -> void:
	#This seems like a really dumb way to randomize the imposter, but it works
	for index in range(1,101):
		imposter_ID.append(index)
		
	imposter_ID.shuffle()
	imposter_subset =  imposter_ID.slice(0,GameStats.imposter_count)
	
	spawn_count()


func spawn_count() -> void:
	while GameStats.count_count < GameStats.max_count:
		##LOOK MORE INTO HOW THESE LINES OF CODE WORKS, FOR KNOWLEDGE SAKE
		var shape = collision_shape_2d.shape as RectangleShape2D
		var size = shape.extents
		var origin = collision_shape_2d.global_position
		
		var random_x = randf_range(origin.x - size.x, origin.x + size.x)
		var random_y = randf_range(origin.y - size.y, origin.y + size.y)
	
		var count = count_to_spawn.instantiate()
		count.global_position = Vector2(random_x, random_y)
		count.id = spawn_id 
		
		if spawn_id in imposter_subset:
			print(imposter_subset)
			count.imposter = true
		
		get_parent().call_deferred("add_child", count)
		
		level_manager.count_spawned()
		spawn_id += 1
	
	GameStats.count_count -= GameStats.imposter_count
	print(GameStats.count_count)
