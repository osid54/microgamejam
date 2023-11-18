extends Node2D

func _ready():
	$Sprite2D.frame = randi_range(0,8)
	modulate = Color(randf_range(.8,1.2)*modulate.r,
				randf_range(.8,1.2)*modulate.g,
				randf_range(.8,1.2)*modulate.b)
	if randi_range(0,1)==1:
		$Sprite2D.flip_h = true
	if randi_range(0,1)==1:
		$Sprite2D.flip_y = true
	$Sprite2D.rotation_degrees = randi_range(-180,180)
	
func _process(delta):
	pass
