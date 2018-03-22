# player.gd

extends KinematicBody2D

signal player_fell  # ~connected with main
signal player_shoot(position) # ~connected with main, player_bullet

onready var global = get_node("/root/global")
onready var sprite = $sprite
#onready var enemy = get_node("../enemy")
onready var collision = $collision


const ACCEL = 1500
const MAX_SPEED = 500
const FRICTION = -500
const GRAVITY = 2000
const JUMP = -1000

var acc = Vector2()
var vel = Vector2()
var anim = "idle"
var got_hit = false
var player_fell = false


func _ready():
	set_process_input(true)
	global.set_player_facing("right")


func _input(event):
		if event.is_action_pressed("ui_left"):
			global.set_player_facing("left")
		if event.is_action_pressed("ui_right"):
			global.set_player_facing("right")
		if event.is_action_pressed("ui_up") and is_on_floor():
			vel.y = JUMP
		if event.is_action_pressed("ui_shoot"):
			print("player: SHOOT!")
			print("player" + str(get_position()))
			emit_signal("player_shoot", get_position())


func _physics_process(delta):

	# Turn off gravity, while player stands on a floor
	if is_on_floor():
		acc.y = 0
	else:
		acc.y = GRAVITY

	
	# MOVEMENT
	# Check if buttons are pressed (left and right)
	acc.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")) # acc.x <= -1 | 0 | 1
	acc.x *= ACCEL # acc.x <= -1500 | 0 | 1500

	# If no button is pressed, decrease the acc.x -value
	# -> acc.x may become zero == player stops
	if acc.x == 0:
		acc.x = vel.x * FRICTION * delta # f.e. acc.x <= 500 * -500 * 0.01667
	
	# Calculate the actual velocity (movement-speed) in px/s
	vel += acc * delta

	# Limit the velocity if buttons are pressed long
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	move_and_slide(vel, Vector2(0,-1))
	
	# ANIMATION
	# Set animation
	if abs(vel.x) < 10: # ~vel.x would never be zero
		vel.x = 0		# ~only becomes infinitely small
	
	# Walk and stand
	if vel.x == 0:
		anim = "idle"
	else:
		anim = "running"

	# Jump and fall
	if is_on_floor() == false:
		anim = "jump"
		if vel.y > 0:
			anim = "fall"
	
	# Got hit
	if got_hit == true: # ~set in _on_player_hit()
		anim = "got_hit"
	
	# Fall out of screen
	if get_position().y >= 500:
		if got_hit == true: # ~set in _on_player_hit()
			pass
		elif player_fell == true:
			pass
		else:
			player_fell = true
			emit_signal("player_fell")
			anim = "fall"
	
	# Turn around
	if vel.x > 0:
		sprite.set_flip_h (false)
	elif vel. x < 0:
		sprite.set_flip_h(true)

	sprite.play(anim)

