# menu.gd

extends Node

onready var global = get_node("/root/global")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_play_btn_button_up():
	global.setScene("res://scenes/main.tscn")


func _on_exit_btn_button_up():
	get_tree().quit()

func _on_touch_play_pressed():
	global.setScene("res://scenes/main.tscn")

func _on_touch_exit_pressed():
	get_tree().quit()
