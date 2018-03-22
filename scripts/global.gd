# global.gd

extends Node

var currentScene = null
var game_won = null
var player_facing = null

func _ready():
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1 )
	print("global: _ready scene = " + get_path_to(currentScene))

func setScene(scene):
	currentScene.queue_free()
	var s = ResourceLoader.load(scene)
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)
	print("global: scene set to " + get_path_to(currentScene))

func is_gameWon():
	return game_won

func set_gameWon(value):
	game_won = value

func set_player_facing(facing):
	player_facing = facing # ~string: "left" or "right"

func get_player_facing():
	return player_facing # ~string: "left" or "right"