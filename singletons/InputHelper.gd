extends Node

## Helper singleton for rebinding actions and getting human readable names for the bindings
## Relies on the Saver singleton

## returns a human readable string for an InputEvent
func get_input_event_as_text(input_event: InputEvent) -> String:
	var text:String = ""
	if input_event is InputEventMouseButton:
		match(input_event.button_index):
			MOUSE_BUTTON_LEFT: text = "Mouse Left"
			MOUSE_BUTTON_RIGHT: text = "Mouse Right"
			MOUSE_BUTTON_MIDDLE: text = "Mouse Middle"
			MOUSE_BUTTON_WHEEL_UP: text = "Mouse Wheel Up"
			MOUSE_BUTTON_WHEEL_DOWN: text = "Mouse Wheel Down"
			MOUSE_BUTTON_WHEEL_LEFT: text = "Mouse Wheel Left"
			MOUSE_BUTTON_WHEEL_RIGHT: text = "Mouse Wheel Right"
			MOUSE_BUTTON_XBUTTON1: text = "Mouse Button Back"
			MOUSE_BUTTON_XBUTTON2: text = "Mouse Button Forward"
	elif input_event is InputEventJoypadMotion:
		match(input_event.axis):
			JOY_AXIS_LEFT_X: text = "Left Joy Axis X"
			JOY_AXIS_LEFT_Y: text = "Left Joy Axis Y"
			JOY_AXIS_RIGHT_X: text = "Right Joy Axis X"
			JOY_AXIS_RIGHT_Y: text = "Right Joy Axis Y"
			JOY_AXIS_TRIGGER_LEFT: text = "Left Trigger"
			JOY_AXIS_TRIGGER_RIGHT: text = "Right Trigger"
			_: text = "Joy Axis"
		var joy_pos = sign(input_event.axis_value)
		if(joy_pos > 0):
			text += "+"
		else:
			text += "-"
	elif input_event is InputEventJoypadButton:
		match(input_event.button_index):
			JOY_BUTTON_A: text = "Joy Button A"
			JOY_BUTTON_B: text = "Joy Button B"
			JOY_BUTTON_X: text = "Joy Button X"
			JOY_BUTTON_Y: text = "Joy Button Y"
			JOY_BUTTON_BACK: text = "Joy Button Back"
			JOY_BUTTON_GUIDE: text = "Joy Button Guide"
			JOY_BUTTON_START: text = "Joy Button Start"
			JOY_BUTTON_DPAD_UP: text = "Joy DPad Up"
			JOY_BUTTON_DPAD_DOWN: text = "Joy DPad Down"
			JOY_BUTTON_DPAD_LEFT: text = "Joy DPad Left"
			JOY_BUTTON_DPAD_RIGHT: text = "Joy DPad Right"
			JOY_BUTTON_LEFT_SHOULDER: text = "Joy Left Shoulder"
			JOY_BUTTON_RIGHT_SHOULDER: text = "Joy Right Shoulder"
			JOY_BUTTON_LEFT_STICK: text = "Joy Left Stick"
			JOY_BUTTON_RIGHT_STICK: text = "Joy Right Stick"
			JOY_BUTTON_PADDLE1: text = "Joy Paddle 1"
			JOY_BUTTON_PADDLE2: text = "Joy Paddle 2"
			JOY_BUTTON_PADDLE3: text = "Joy Paddle 3"
			JOY_BUTTON_PADDLE4: text = "Joy Paddle 4"
			JOY_BUTTON_TOUCHPAD: text = "Joy Touchpad"
	elif input_event is InputEventKey:
		if(input_event.keycode == 0):
			text = OS.get_keycode_string(input_event.physical_keycode)
		else:
			text = OS.get_keycode_string(input_event.keycode)
	if(text == ""):
		# we dont know what this is, give up and use godot's text
		text = input_event.as_text()
	return text

## Encodes an InputEvent as a dictionary so it can be saved to a file
func event_to_dict(e:InputEvent):
	if(e is InputEventKey):
		if(e.keycode == 0):
			return {"type":"physical key", "scancode":e.physical_keycode}
		else:
			return {"type":"key", "scancode":e.keycode}
	if(e is InputEventMouseButton):
		return {"type":"mouse button", "index":e.button_index}
	if(e is InputEventJoypadButton):
		return {"type":"joypad button", "index":e.button_index}
	if(e is InputEventJoypadMotion):
		return {"type":"joypad motion", "axis":e.axis, "axis value":sign(e.axis_value)}

## Decodes a dictionary to get an InputEvent
func dict_to_event(d:Dictionary) -> InputEvent:
	match d["type"]:
		"key":
			var e := InputEventKey.new()
			e.set_keycode(d["scancode"])
			return e
		"physical key":
			var e := InputEventKey.new()
			e.set_pysical_keycode(d["scancode"])
			return e
		"mouse button":
			var e = InputEventMouseButton.new()
			e.set_button_index(d["index"])
			return e
		"joypad button":
			var e := InputEventJoypadButton.new()
			e.set_button_index(d["index"])
			return e
		"joypad motion":
			var e := InputEventJoypadMotion.new()
			e.set_axis(d["axis"])
			e.set_axis_value(d["axis value"])
			return e
	return null

## saves a rebind using Saver
func save_rebind(action:String, event:InputEvent, insert_index:int):
	var rebinds = Saver.get_value("rebinds")
	if(rebinds == null):
		rebinds = {}
	if(not rebinds.has(action)):
		rebinds[action] = {}
	rebinds[action][str(insert_index)] = event_to_dict(event)
	Saver.set_value("rebinds", rebinds)

## load rebinds from Saver
func load_rebinds():
	var rebinds = Saver.get_value("rebinds")
	if(rebinds == null):
		rebinds = {}
	for action in rebinds:
		for insert_index in rebinds[action]:
			rebind_action(action, dict_to_event(rebinds[action][insert_index]), insert_index.to_int())

## applies a rebind
func rebind_action(action:String, event:InputEvent, insert_index:int=-1):
	var events:Array = InputMap.action_get_events(action)
	# remove all the events after this event
	var removed_events = []
	for i in range(posmod(insert_index, len(events))+1, len(events)):
		removed_events.append(events[i])
		InputMap.action_erase_event(action, events[i])
	# erase the old event
	InputMap.action_erase_event(action, events[insert_index])
	# add the new event
	InputMap.action_add_event(action, event)
	# add all the removed events back
	for e in removed_events:
		InputMap.action_add_event(action, e)

## get the human readable binding for an action
## useful for prompts
func get_action_binding_as_text(action:String, index:int=-1) -> String:
	var events:Array = InputMap.action_get_events(action)
	return get_input_event_as_text(events[posmod(index, len(events))])

## emitted when we reset rebinds
signal reset_binds

## resets all bindings to default
func reset_rebinds():
	InputMap.load_from_project_settings()
	Saver.set_value("rebinds", {})
	emit_signal("reset_binds")

func _ready():
	# when we start the game, we want to load all of our bindings from Saver
	load_rebinds()
