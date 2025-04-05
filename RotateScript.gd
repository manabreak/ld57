class_name RotateScript
extends Area3D

const SPEED = 6.0
const STEP = 45.0

@export
var start_orientation: Vector3

signal rotated(RotateScript)
signal clicked(RotateScript)

## The correct solution orientation
var solution: Quaternion = Quaternion.IDENTITY

## Slerp target
var target_rotation: Quaternion = Quaternion.IDENTITY

var container_rot_index: int = 0
var selected = false
var slerping = true

func stop_slerp() -> void:
	slerping = false

func _process(delta: float) -> void:
	if not selected:
		return
	
	if Input.is_action_just_pressed("rotate_down"):
		rotate_down()
	elif Input.is_action_just_pressed("rotate_up"):
		rotate_up()
	elif Input.is_action_just_pressed("rotate_left"):
		rotate_left()
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_right()
	elif Input.is_action_just_pressed("move_up"):
		move_up()
	elif Input.is_action_just_pressed("move_down"):
		move_down()
	elif Input.is_action_just_pressed("move_left"):
		move_left()
	elif Input.is_action_just_pressed("move_right"):
		move_right()


func move_up() -> void:
	position.y += 0.5
	emit_signal("rotated", self)


func move_down() -> void:
	position.y -= 0.5
	emit_signal("rotated", self)


func move_left() -> void:
	position.x -= 0.5
	emit_signal("rotated", self)


func move_right() -> void:
	position.x += 0.5
	emit_signal("rotated", self)


func _physics_process(delta: float) -> void:
	if not slerping:
		return
	
	var current_quat = transform.basis.get_rotation_quaternion()
	var new_quat = current_quat.slerp(target_rotation, delta * SPEED)
	transform.basis = Basis(new_quat)


func rotate_down() -> void:
	var axis = Vector3(1, 0, 0)
	axis = axis.rotated(Vector3.UP, deg_to_rad(-90) * container_rot_index)
	target_rotation = Quaternion(axis, deg_to_rad(STEP)) * target_rotation
	emit_signal("rotated", self)


func rotate_up() -> void:
	var axis = Vector3(1, 0, 0)
	axis = axis.rotated(Vector3.UP, deg_to_rad(-90) * container_rot_index)
	target_rotation = Quaternion(axis, deg_to_rad(-STEP)) * target_rotation
	emit_signal("rotated", self)


func rotate_left() -> void:
	target_rotation = Quaternion(Vector3.UP, deg_to_rad(-STEP)) * target_rotation
	emit_signal("rotated", self)


func rotate_right() -> void:
	target_rotation = Quaternion(Vector3.UP, deg_to_rad(STEP)) * target_rotation
	emit_signal("rotated", self)


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("Clicked a cube at index " + str(get_index()))
		emit_signal("clicked", self)
