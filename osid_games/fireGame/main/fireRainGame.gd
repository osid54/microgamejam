extends Microgame

@onready var umbrella = $Path2D/PathFollow2D
@onready var player = $fireBall
var go = true
var lose = false
var win = false

func _ready():
	umbrella.progress_ratio = .5
	player.position.x = 1152/2.0
	set_process(false)

func _process(delta):
	umbrella.get_child(0).position.y += randi_range(-32,32)*delta
	umbrella.get_child(0).rotation+=randf_range(-PI/4,PI/4)*delta
	if lose:
		player.kill()
		return
	if win:
		return
	if go:
		move()

func _on_start_game():
	set_process(true)

func _on_timeout():
	if !lose:
		win = true
		player.win = true
		player.SPEED = 0
		$rain.emitting = false
		for i in 100:
			$skyLight.energy = move_toward(1,.5,(i+1.0)/100)
			await get_tree().create_timer(1.0/100).timeout
		won.emit()

func move():
	go = false
	var start = umbrella.progress_ratio
	var end = randf()
	var time = (abs(end-start)*2*1)*(1-.6*GlobalData.speed)
	for i in 100:
		if lose or win:
			break
		umbrella.progress_ratio = lerp(start,end,(i+1.0)/100)
		await get_tree().create_timer(time/100).timeout
	go = true

func fireballOut(_area):
	lost.emit()
	lose = true
	player.SPEED = 0
