extends KinematicBody

var speed = 10
var acceleration = 10
onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jump_height = 100

var mouse_sensitivity = 0.10

var direction : Vector3
var velocity : Vector3
var fall : Vector3

onready var head = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x , deg2rad(-90), deg2rad(90))
		
func _physics_process(delta):
	direction = Vector3.ZERO
	
	move_and_slide(fall, Vector3.UP)
	
	if not is_on_floor():
		fall.y -= gravity 
		
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		fall.y = jump_height
		
	if Input.is_action_pressed("ui_up"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("ui_down"):
		direction += transform.basis.z
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("ui_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed , acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
