extends Spatial

export var speed = 1

# Variables for arcball rotation
var _dragging = false

var _theta = 0 # Polar angle
var _phi = 0 # Azimuthal angle
var _flat_basis = Basis() # Basis without phi translation

onready var _screen_dim = get_viewport().size # To project to ndc arcball point

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		_dragging = event.pressed
	if event is InputEventMouseMotion and _dragging:
		var motion = event.relative / _screen_dim
		rotate_polar_angles(motion.x, motion.y)

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
	
func to_ndc(screen_point : Vector2) -> Vector2:
	var res = Vector2()
	res.x = 2 * screen_point.x / _screen_dim.x - 1
	res.y = 1 - 2 * screen_point.y / _screen_dim.y
	return res
	
func rotate_polar_angles(dtheta : float, dphi : float):
	_theta = fposmod(_theta + dtheta, 2 * PI)
	_flat_basis = Basis().rotated(Vector3.FORWARD, _theta)
	_phi = clamp(_phi + dphi, 0, 1.5)
	transform.basis = _flat_basis.rotated(_flat_basis.x, _phi)
	transform.origin.z = transform.basis.z.z
