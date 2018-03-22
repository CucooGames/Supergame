# gem_red.gd

extends Area2D

onready var sprite = $sprite
onready var tween_vanish = $tween_vanish
onready var collision = $collision

signal gem_red_grabbed

func _ready():
	tween_vanish.interpolate_property(sprite, 'scale', sprite.get_scale(), \
								Vector2(2.0, 2.0), 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween_vanish.interpolate_property(sprite, 'modulate', get_modulate(), Color(1, 1, 1, 0) , 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)



func _on_gem_red_body_entered( body ):
	print("test")
	var name  = body.get_name()
	if name.begins_with("player"):
		emit_signal("gem_red_grabbed")
		collision.disabled = true
		tween_vanish.start()
