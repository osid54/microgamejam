extends Microgame

var go := false
var lose := true
var attack := false

@onready var enemy = $enemy/rig/AnimationPlayer
@onready var player = $player/rigPlayer/AnimationPlayer

func _ready():
	enemy.play("start_crouch")
	player.play("start")

func _process(_delta):
	if attack:
		return
	if Input.is_action_just_pressed("action"):
		hit()

func _on_start_game():
	await get_tree().create_timer(randf_range(.1*$MicrogameTimer.wait_time,.8*$MicrogameTimer.wait_time)).timeout
	if attack:
		return
	go = true
	#eyes pop in, unsheath
	enemy.play("unsheath")
	await get_tree().create_timer(.8-.5*GlobalData.speed).timeout
	go = false
	enemy.play("slice")
	if !attack and lose:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property($enemy, "position", $enemy.position-Vector2(700,0), 1)
		player.play("attack")
		await get_tree().create_timer(1).timeout
		print("!attack and lose")
		player.play("attackDeath")
		enemy.play("sheathBig")
		await enemy.animation_finished
		lost.emit()
	elif attack and !lose:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property($enemy, "position", $enemy.position-Vector2(600,0), 1)
		playerMove(0)
		player.play("attack")
		await get_tree().create_timer(1).timeout
		enemy.play("death")
		player.play("win")
		print("attack and !lose")
		await enemy.animation_finished
		won.emit()

func hit():
	if !attack:
		attack = true
		if go:
			lose = false
		else:
			go = false
			enemy.play("slice")
			playerMove(100)
			player.play("attack")
			await get_tree().create_timer(1).timeout
			player.play("attackDeath")
			enemy.play("sheathBig")
			await enemy.animation_finished
			print("attack and lose")
			lost.emit()
	go = false

func _on_timeout():
	pass
#	if !lose:
#		lost.emit()

func playerMove(amount):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property($player, "position", $player.position+Vector2(550+amount,0), 1)
