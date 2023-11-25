extends CharacterBody2D

var SPEED = 700.0

func _ready():
	SPEED*=(1+.5*GlobalData.speed)

func _physics_process(_delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
