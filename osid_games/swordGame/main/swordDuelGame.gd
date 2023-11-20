extends Microgame

var go := false
var lose := false

func _process(_delta):
	if lose:
		return
	if Input.is_action_just_pressed("action"):
		hit()

func _on_start_game():
	await get_tree().create_timer(randf_range(.2*%MicrogameTimer.wait_time,.9*%MicrogameTimer.wait_time)).timeout
	go = true
	await get_tree().create_timer(.5).timeout

func hit():
	if !go:
		lose = true
		lost.emit()

func _on_timeout():
	lost.emit()
