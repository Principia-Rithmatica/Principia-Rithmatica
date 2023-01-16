extends Node

var _lines = [PoolVector2Array()]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func input_point(position : Vector2):
	var line = _lines.pop_back()
	line.append(position)
	_lines.append(line)

func finish_line():
	_lines.push_back(PoolVector2Array())

func _process(_delta):
	$Canvas.set_lines(_lines)
