extends CanvasLayer

# IMPORTANT:
# change this file at your own risk.
# your microgame will be run in a version of this project without your changes.

@onready var animation_player: AnimationPlayer = $AnimationPlayer

## tells the microgame to start
signal start_game

func _ready():
	# make the animation get faster with GlobalData.speed
	animation_player.speed_scale = lerp(1.0, 2.0, GlobalData.speed)
	# make the action label scale around its center
	$Control/ActionLabel.pivot_offset = $Control/ActionLabel.size/2
	# this gives the text a slight 3d effect as it gets animated
	$Control/ActionLabel.pivot_offset.y -= 40

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			# after we fade in, fade out
			animation_player.play("fade_out")

# gets called from the animation player
func fade_almost_done():
	# start the game slightly before the fade is done
	start_game.emit()
