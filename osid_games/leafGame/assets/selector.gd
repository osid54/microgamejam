extends CharacterBody2D

@export var speed = 700.0
var go = true

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(_delta):
	if go:
		var direction = Input.get_vector("left", "right","up","down")
		if direction:
			velocity = direction * speed
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed)

		move_and_slide()

func checkLeaf():
	for a in $Area2D.get_overlapping_areas():
		if a.isGolden:
			return true
	return false

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "default" or $AnimatedSprite2D.animation == "fail":
		if randi_range(0,1):
			$AnimatedSprite2D.flip_h = true
		if randi_range(0,1):
			$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.flip_v = false

func change(win):
	if win:
		$AnimatedSprite2D/ColorRect.color = Color("GREEN")
		#$AnimatedSprite2D.play("win")
	else:
		$AnimatedSprite2D/ColorRect.color = Color("RED")
		#$AnimatedSprite2D.play("fail")
