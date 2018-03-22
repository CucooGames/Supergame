# gem_yellow.gd

extends Area2D

onready var global = get_node("/root/global")
onready var sprite = $sprite
onready var tween_vanish = $tween_vanish
onready var collision = $collision

signal gem_yellow_grabbed

func _ready():
	tween_vanish.interpolate_property(sprite, 'scale', sprite.get_scale(), \
								Vector2(2.0, 2.0), 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween_vanish.interpolate_property(sprite, 'modulate', get_modulate(), Color(1, 1, 1, 0) , 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)



func _on_gem_body_entered( body ):
	if global.is_gameWon() == false:
		var name  = body.get_name()
		if name.begins_with("player"):
			emit_signal("gem_yellow_grabbed")
			collision.disabled = true
			tween_vanish.start()
	else:
		pass