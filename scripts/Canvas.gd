extends ColorRect

var dragging = false
var lines = []
var width = 1.0
var antialiased = true

func _ready():
	pass
	
func _draw():
	var cnt = 0
	for i in lines:
		++cnt
		draw_polyline(i, Color.white, width, antialiased)

func _process(_delta):
	update()
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		print_debug('Mouse pressed')
		dragging = event.pressed
		if event.pressed:
			lines.append(PoolVector2Array())
			
	if event is InputEventMouseMotion and dragging:
#		WHAT THE HECK IS THIS???
#		Okay, yeah, Godot can be finicky occasionally.
#		lines[-1].append(event.position)
		var v = lines.pop_back()
		v.append(event.position)
		lines.append(v)
