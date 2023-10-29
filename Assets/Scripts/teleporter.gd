extends StaticBody2D

var player
var start_teleport = false
var timer
var back_to_normal
var host
var spriteon
var spriteoff
var level
@onready var sound = $teleportSound

# Called when the node enters the scene tree for the first time.
func _ready():
	spriteon = $teleporter_on
	spriteoff = $teleporter_off
	timer = 5
	player  = get_tree().get_root().get_node("Node2D").get_node("Martin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if timer <= 0:
		spriteon.visible = true
		spriteoff.visible = false
		if back_to_normal <= 0:
			sound.play()
			if host:
				host.queue_free()
			spriteon.visible = false
			spriteoff.visible = true
			timer = 5
			back_to_normal = 3
			host = null
			player.hosts += 1
		else: 
			back_to_normal -= 0.1
	else:
		if host:
			timer -= 0.05
			back_to_normal = 3


func _on_area_2d_body_entered(body):
	if body.is_in_group("host"):
		host = body
		body.isFollowingPlayer = false
		body.isSafe = true
		
