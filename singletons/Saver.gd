extends Node

## This script will save data to a file, and retrieve it from a file.
## Intended to be used as a Singleton.
## The data must be in key/value pairs.
## To set/get data, call get_value(key) or set_value(key, value) from somewhere else.

## filename in user://
@export var save_file:String = "save"

## will save to the file every time you set some data.
## may write a lot depending on application, use with caution.
## to avoid many disk writes, prefer manually calling save_to_file() only when needed.
@export var save_on_set:bool = false

## automatically read data from file on startup.
@export var load_on_ready:bool = true

var data:Dictionary = {}

## saves a value
func set_value(key, value):
	data[key] = value
	if(save_on_set):
		save_to_file()

## loads a value
func get_value(key):
	if(not key in data):
		return null
	return data[key]

func _ready():
	save_timer.wait_time = 1.0
	save_timer.one_shot = true
	save_timer.autostart = false
	save_timer.timeout.connect(on_save_timer_timout)
	add_child(save_timer)
	if(load_on_ready):
		load_from_file()

# this will run when the game exits.
# in web builds, it may not run, save_on_write = true may be needed.
func _exit_tree():
	save_to_file()

func save_to_file():
	var dump:String = JSON.stringify(data) # dump data to a string
	var f := FileAccess.open("user://%s"%save_file, FileAccess.WRITE)
	if(FileAccess.get_open_error() == OK):
		f.store_string(dump)
		f.close()
	else:
		print("There was a problem saving data to a file.\nError #%d"%f.get_error())

func load_from_file():
	var f := FileAccess.open("user://%s"%save_file, FileAccess.READ)
	if(FileAccess.get_open_error() == OK):
		var text:String = f.get_as_text()
		f.close()
		var json:JSON = JSON.new()
		if(json.parse(text) == OK and json.get_data() is Dictionary):
			data.merge(json.get_data(), true) # overwrite the current dict with new values
		else:
			print("Invalid JSON in save file.")
			print(json.get_error_message())
			save_to_file() # overwrite invalid json data.
	else:
		# dont print the error message for a file not found
		if(FileAccess.get_open_error() != ERR_FILE_NOT_FOUND):
			print("There was a problem loading data from a file\nError #%d"%FileAccess.get_open_error())

@onready var save_timer := Timer.new()
func save_after_timer():
	save_timer.start()

func on_save_timer_timout():
	save_to_file()
