extends Microgame

@export var leaf : PackedScene
var leaves := []
var density := 80
func _on_start_game():
	var xInterval = int(get_viewport().get_window().size.x/float(density))
	var yInterval = int((get_viewport().get_window().size.y-64)/float(density))
	for i in yInterval:
		leaves.append([])
		for j in xInterval:
			var l = leaf.instantiate()
			l.position = Vector2(64+j*density,64+i*density)
			leaves[i].append(l)
			add_child(l)
	leaves.pick_random().pick_random().makeGold()
	$Selector.position = Vector2(get_viewport().get_window().size.x/2.0, (get_viewport().get_window().size.y-64)/2.0)
	$Selector.visible = true

func _process(_delta):
	if Input.is_action_just_pressed("action"):
		if $Selector.checkLeaf():
			won.emit()
		else:
			lost.emit()
