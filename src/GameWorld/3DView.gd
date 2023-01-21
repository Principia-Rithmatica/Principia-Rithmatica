extends Spatial

var _dragging = false

onready var _camera = $MovableCamera3D
onready var _viewport_size = $GameWorld3D/Viewport.size
onready var _world = $GameWorld3D/Viewport/GameWorld2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_dragging = event.pressed
		if !event.pressed:
			_world.finish_line()
	if event is InputEventMouseMotion and _dragging:
		var origin = _camera.project_ray_origin(event.position)
		var direction = _camera.project_ray_normal(event.position)
		direction = direction.normalized()
		var world3dIntersection = origin - (origin.y / direction.y) * direction
		var world2dIntersection = (Vector2(world3dIntersection.x, world3dIntersection.z) + Vector2(1, 1)) / 2 * _viewport_size
		_world.input_point(world2dIntersection)


