extends CharacterBody2D

@export var speed = 700.0

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(_delta):
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
