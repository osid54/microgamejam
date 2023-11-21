extends Microgame

var go := false
var lose := true
var attack := false

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
	$enemy.play("unsheath")
	await get_tree().create_timer(1).timeout
	go = false
	if !attack and lose:
		print("!attack and lose")
		#stabbed animation
		$enemy.position.x -= 500
		$enemy.play("sheath")
		await $enemy.animation_finished
		lost.emit()
	elif attack and !lose:
		#cross animation
		print("attack and !lose")
		$enemy.position.x -= 500
		$enemy.play("sheath")
		await $enemy.animation_finished
		won.emit()

func hit():
	if !attack:
		attack = true
		if go:
			lose = false
		else:
			#attack but stabbed
			print("attack and lose")
			lost.emit()
	go = false

func _on_timeout():
	pass
#	if !lose:
#		lost.emit()
