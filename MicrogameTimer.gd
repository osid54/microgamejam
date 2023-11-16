extends Timer

# IMPORTANT:
# change this file at your own risk.
# your microgame will be run in a version of this project without your changes.

## the minimum amount of time that the player will be given for your microgame.
## this time will be used when GlobalData.speed is 1.0
@export var min_time := 1.0
## the maximum amount of time that the player will be given for your microgame.
## this time will be used when GlobalData.speed is 0.0
@export var max_time := 1.0

func _ready():
	wait_time = lerp(max_time, min_time, GlobalData.speed)
	# dont update the timer bar before the timer starts
	set_process(false)

func _on_start_game():
	start()
	# we started the timer, so we must update the timer bar
	set_process(true)

@onready var timer_bar = %TimerBar
func _process(delta):
	# update the timer bar
	timer_bar.value = time_left/wait_time

func _on_timeout():
	timer_bar.value = 0.0
	# the timer isn't running anymore, so we dont need to update the timer bar
	set_process(false)
