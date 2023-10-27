extends Node2D

var spawn_time
var spawn_range

# Constant params
const EnemyPath = preload("res://Assets/Prefabs/jonhy.tscn")
const robotPath = preload("res://Assets/Prefabs/robot.tscn")
const enemies = [EnemyPath, robotPath]
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_time = 0
	spawn_range = randi_range(1,3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawn_time <= 0:
		spawn_time = randi_range(400,500)
		spawn_range = randi_range(1,3)
		spawner(spawn_range)
		pass
	else:
		spawn_time -= 0.05


func spawner(range):
	for n in range:
		var enemy = enemies[randi_range(0,1)].instantiate()
		get_parent().add_child(enemy)
		var _position = $spanwer_1.global_position
		_position.x += randi_range(-10, 10)
		_position.y += randi_range(-10, 10)
		enemy.position = _position
		
