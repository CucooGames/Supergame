# main3.gd
# TouchScreenButton

extends Node

onready var global = get_node("/root/global")
onready var camera = $player/camera
onready var player_bullet = load("res://scenes/player_bullet.tscn")
onready var player = $player
onready var player_collision = $player/collision
onready var gem_red = $gem_red
onready var anim_slide_in = $canvas/HUD/game_over_label/anim_slide_in
onready var anim_slide_in_won = $canvas/HUD/game_won_label/anim_slide_in
onready var score_label = $canvas/HUD/score_label
onready var play_btn = $canvas/HUD/play_btn
onready var replay_btn = $canvas/HUD/replay_btn
onready var exit_btn = $canvas/HUD/exit_btn

var score = 0
var points = 10
var points_red_gem = 50


func _ready():
	player.connect("player_shoot", self, "_on_player_shoot")
	play_btn.set_visible(false)
	replay_btn.set_visible(false)
	exit_btn.set_visible(false)
	global.set_gameWon(false)
	
		# Connect the signals for
	# ...the enemies
	for child in get_children():
		var child_path = (str(child.get_path()))
		if "enemy" in child_path:
			var enemy = child.get_node(child_path)
			enemy.connect("player_hit", self, "_on_player_hit")

	# ...the player
	player.connect("player_fell", self, "_on_player_fell")

	# ... the gems
	for child in get_children():
		var child_path = str(child.get_path())
		if "gem_yellow" in child_path:
			var gem = child.get_node(child_path)
			gem.connect("gem_yellow_grabbed", self, "_on_gem_yellow_grabbed")
	
	gem_red.connect("gem_red_grabbed", self, "_on_gem_red_grabbed")
	
#func _process(delta):
#	pass
	
	
func _on_gem_yellow_grabbed():
	if global.is_gameWon() == false:
		print("main3: gem_yellow_grabbed")
		score += points
		score_label.set_text(str(score))
	else:
		pass

func _on_gem_red_grabbed():
	print("main3: gem_red_grabbed")
	score += points_red_gem
	score_label.set_text(str(score))
	game_won()
	
func _on_player_hit():
	print("main3: player_hit")
	#player.hide()
	#player_collision.disabled = true
	game_over()

func _on_player_fell():
	print("main3: player_fell")
	game_over()

func game_over():
	if global.is_gameWon() == false: # ~ set in game_won()
		anim_slide_in.play("game_over_slide_in")
		camera.clear_current()
		replay_btn.set_visible(true)
		exit_btn.set_visible(true)
	else:
		pass

func game_won():
	global.set_gameWon(true)
	anim_slide_in_won.play("game_won_slide_in")
	play_btn.set_visible(true)
	replay_btn.set_visible(true)
	exit_btn.set_visible(true)

func _on_player_shoot(player_position):
	print("main: SHOOT!")
	var bullet_instance = player_bullet.instance()
	bullet_instance.position = player_position
	self.add_child(bullet_instance)
	bullet_instance.connect("enemy_hit", self, "_on_enemy_hit")

func _on_enemy_hit(enemy_name):
	var enemy = get_node(enemy_name)
	enemy.queue_free()

func _on_play_btn_button_up():
	# Return to menu because
	# main3 is the last level for now.
	global.setScene("res://scenes/menu.tscn")
	
func _on_replay_btn_button_up():
	global.setScene("res://scenes/main3.tscn")

func _on_exit_btn_button_up():
	global.setScene("res://scenes/menu.tscn")