extends ColorRect

export var _color = Color.white
export var _width = 1.0
export var _antialiased = true

var _lines = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_lines(lines):
	_lines = lines

func _draw():
	for line in _lines:
		if (line.size() >= 2): draw_polyline(line, _color,  _width, _antialiased)
		
func _process(_delta):
	update()
