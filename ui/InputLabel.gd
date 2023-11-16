extends Label
class_name InputLabel

# IMPORTANT:
# change this file at your own risk.
# your microgame will be run in a version of this project without your changes.

@export var actions: Array[String] = ["up", "down", "left", "right", "action"]

func _ready():
	var format_dict = {}
	for action in actions:
		format_dict[action] = InputHelper.get_action_binding_as_text(action)
	text = text.format(format_dict)
