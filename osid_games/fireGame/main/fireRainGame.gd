extends Microgame

@onready var umbrella = $Path2D/PathFollow2D
@onready var player = $fireBall
var go = true
var lose = false

func _ready():
	umbrella.progress_ratio = .5
	player.position.x = 1152/2.0
	set_process(false)

func _process(delta):
	if lose:
		set_process(false)
		return
	if go:
		move()
	$Path2D/PathFollow2D/Sprite2D.rotation+=randf_range(-PI/4,PI/4)*delta
	player.position.y+=randi_range(-32,32)*delta

func _on_start_game():
	set_process(true)

func _on_timeout():
	won.emit()

func move():
	go = false
	var start = umbrella.progress_ratio
	var end = randf()
	var time = (abs(end-start)*2*1)*(1-.6*GlobalData.speed)
	print(time)
	for i in 100:
		if lose:
			break
		umbrella.progress_ratio = lerp(start,end,(i+1.0)/100)
		await get_tree().create_timer(time/100).timeout
	go = true

func fireballOut(_area):
	lost.emit()
	lose = true
	player.SPEED = 0
