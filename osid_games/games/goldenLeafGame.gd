extends Microgame

@export var leaf : PackedScene
var leaves := []
func _on_start_game():
	var xInterval = get_viewport().get_window().size.x/128
	var yInterval = (get_viewport().get_window().size.y)/128
	for i in yInterval:
		for j in xInterval:
			var l = leaf.instantiate()
			l.position = Vector2(64+j*128,64+i*128)
			leaves.append(l)
			add_child(l)
