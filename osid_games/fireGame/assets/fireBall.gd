extends CharacterBody2D

var SPEED = 700.0
var lose = false
var win = false

func _ready():
	SPEED*=(1+.5*GlobalData.speed)

func _physics_process(_delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	position.y += randi_range(-32,32)*delta
	$Sprite2D.rotation += PI/4*delta
	if lose:
		return
	$PointLight2D.scale.x += randf_range(-1,1)*delta
	$PointLight2D.scale.y += randf_range(-1,1)*delta

func kill():
	if !lose:
		lose = true
		$flameParticles.emitting = false
		lightOff()
	
func lightOff():
	$halo.visible = false
	$Sprite2D.play("death")
	var startScale = $PointLight2D.scale
	var time = 32
	for i in time:
		$PointLight2D.scale = startScale.lerp(Vector2(0,0), (i*1.0)/time)
		await get_tree().create_timer(.5/time).timeout
	$PointLight2D.visible = false
