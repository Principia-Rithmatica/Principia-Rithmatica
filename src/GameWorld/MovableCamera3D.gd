extends Spatial

export var speed = 1

# Variables for arcball rotation
var _dragging = false
var _click_point

onready var _world_basis = transform.basis
onready var _flat_basis = transform.basis # Basis projected onto the XZ plane, for translations
onready var _screen_dim = get_viewport().size # To project to ndc arcball point
onready var _prev_basis = transform.basis #Basis temporary holder for arcball rotation

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		_dragging = event.pressed
		if event.pressed:
			_click_point = to_arcball_point(event.position)
			_prev_basis = transform.basis
		if event.doubleclick:
			print_debug("Doubleclick")
			transform.basis = Basis()
			_flat_basis = Basis()

	if event is InputEventMouseMotion and _dragging:
		arcball_rotate(event.position)

func _process(delta):
	var disp = Vector3()
	if Input.is_action_pressed("ui_right"):
		disp.x += 1
	if Input.is_action_pressed("ui_left"):
		disp.x -= 1
	if Input.is_action_pressed("ui_up"):
		disp.y += 1
	if Input.is_action_pressed("ui_down"):
		disp.y -= 1
	transform.origin += _flat_basis * disp * speed * delta

func to_arcball_point(screen_point : Vector2) -> Vector3:
	var res = Vector3()
	res.x = 2 * screen_point.x / _screen_dim.x - 1
	res.y = 1 - 2 * screen_point.y / _screen_dim.y
	var rsq = res.x * res.x + res.y * res.y
	if rsq < 1:
		res.z = sqrt(1 - rsq)
	return res.normalized()
	
func arcball_rotate(screen_point : Vector2) -> void:
	#Standard arcball rotation
	var drag_point = to_arcball_point(screen_point)
	if (drag_point != _click_point):
		var angle = acos(_click_point.dot(drag_point))
		var axis = _click_point.cross(drag_point).normalized()
		transform.basis = _prev_basis.rotated(axis, angle)
		
		# Move the camera closer to the screen at a low angle
		transform.origin.z = transform.basis.z.z
		
	for i in [0, 1]:
		var col : Vector3 = transform.basis[i]
		col.z = 0		
		_flat_basis[i] = col.normalized()
	_flat_basis.z = _flat_basis.x.cross(_flat_basis.y)
