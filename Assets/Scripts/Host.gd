extends CharacterBody2D

@onready var spr = $AnimatedSprite2D
var life = 3
var isFollowingPlayer = false
var isSafe = false
var player
var deathTimer = 0.05
var speed = 90
var teleporter
var beingTeleported = false

func _ready():
	teleporter = $"../teleporter/safePoint"
	spr.play("Idle")
	player = get_tree().get_root().get_node("Node2D").get_node("Martin")

func _physics_process(delta):
	
	if life <= 0:
		spr.play("Die")
		player.deathHost += 1
		if deathTimer <= 0:
			queue_free()
		else: 
			deathTimer -= 0.01
	else:
		if isFollowingPlayer && !isSafe:
			spr.play("Run")
			var dir = (player.global_position - self.global_position).normalized()
			spr.flip_h = player.spr.flip_h
			move_and_collide(dir * speed * delta)
			
		if isSafe && !isFollowingPlayer:
			spr.play("Run")
			var dir = (teleporter.global_position - self.global_position).normalized()
			spr.flip_h = player.spr.flip_h
			move_and_collide(dir * speed * delta)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if !isSafe:
			isFollowingPlayer = true
	if (body.is_in_group("bullets") && !isFollowingPlayer) || body.is_in_group("enemy_bullets"):
		if life > 0:
			life -= 1
			
func _on_area_2d_area_entered(area):
	if area.is_in_group("teleporter"):
		isFollowingPlayer = false
		isSafe = true
