# enemy.gd

extends Area2D

export (int) var SPEED

signal player_hit # ~connected with main; player

onready var sprite = $sprite
var vel = Vector2(0, 0)



func _ready():
	var anim = "walking"
	sprite.play("walking")

func _process(delta):
	
	if vel.length() > 0:
		vel = vel.normalized() * SPEED
	
	vel.x += -1
	position += vel * delta


func _on_enemy_body_entered( body ):
	var name  = body.get_name()
	if name.begins_with("wall"):
		vel.x *= -1
		if sprite.is_flipped_h():
			sprite.set_flip_h(false)
		else:
			sprite.set_flip_h(true)
	elif name.begins_with("player"):
		emit_signal("player_hit")
