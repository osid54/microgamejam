extends Node
class_name Microgame

# IMPORTANT:
# please dont edit this file, make a new script that inherits this one instead.

## emit this signal to tell the game that your microgame was completed successfully.
signal won
## emit this signal to tell the game that your microgame was completed unsuccessfully.
signal lost

## this function gets called after the action label animation plays.
## you should start your game in here.
func _on_start_game():
	pass

## this function will get called if the player runs out of time during your game.
## you can leave this as is, or override to add some custom animations or something.
func _on_timeout():
	lost.emit()

func _on_game_won():
	print("Your microgame was just won")

func _on_game_lost():
	print("Your microgame was just lost")
