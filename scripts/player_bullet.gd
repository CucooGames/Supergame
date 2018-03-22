# player_bullet.gd

extends Node2D

signal enemy_hit(enemy_name) # ~connected with main3

export (int) var SPEED
onready var global = get_node("/root/global")
onready var timer = $timer

var vel = Vector2(0, 0)
var direction = null
var vel_direction = null


func _ready():
	direction = global.get_player_facing() # ~string: "left", "right"
	if direction == "left":
		vel_direction = -1
	elif direction == "right":
		vel_direction = 1
	
	timer.start()

func _process(delta):
	
	if vel.length() > 0:
		vel = vel.normalized() * SPEED
	vel.x += vel_direction
	#vel.x += -1
	position += vel * delta


func _on_Area2D_area_entered(area):
	var area_name = area.get_name()
	if "enemy" in area_name:
		emit_signal("enemy_hit", area_name)
		queue_free()


func _on_Timer_timeout():
	queue_free()
