extends Microgame

@export var leaf : PackedScene
var leaves := []
var density := 80
var xInterval : int
var yInterval : int
func _on_start_game():
	xInterval = int(1152/float(density))
	yInterval = int((648-64)/float(density))
	for i in yInterval:
		leaves.append([])
		for j in xInterval:
			var l = leaf.instantiate()
			add_child(l)
			l.startPos = 64+j*density
			l.move(64+i*density)
			leaves[i].append(l)
	leaves.pick_random().pick_random().makeGold()
	$Selector.position = Vector2(1152/2.0, (648-64)/2.0)
	$Selector.visible = true

func _on_timeout():
	$Selector.go = false
	var win = $Selector.checkLeaf()
	$Selector.change(win)
	for i in yInterval:
		for j in xInterval:
			leaves[i][j].kill()
	await get_tree().create_timer(2).timeout
	if win:
		won.emit()
	else:
		lost.emit()
