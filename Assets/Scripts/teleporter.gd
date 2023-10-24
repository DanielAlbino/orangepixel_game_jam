extends StaticBody2D

var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player  = get_tree().get_root().get_node("Node2D").get_node("Martin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("host"):
		body.isFollowingPlayer = false
		body.isSafe = true
		player.hosts += 1
