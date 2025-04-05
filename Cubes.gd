class_name Cubes
extends Node3D

const SPEED = 5.0
const STEP = 90.0

var rot_index: int = 0

@export
var start_orientation: Vector3

signal rotated(int)

## The correct solution orientation
var solution: Quaternion = Quaternion.IDENTITY

## Slerp target
var target_rotation: Quaternion = Quaternion.IDENTITY
var slerping = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("container_left"):
		rotate_left()
	elif Input.is_action_just_pressed("container_right"):
		rotate_right()
	#elif Input.is_action_just_pressed("container_up"):
	#	rotate_up()
	#elif Input.is_action_just_pressed("container_down"):
	#	rotate_down()


func _physics_process(delta: float) -> void:
	if not slerping:
		return
	
	var current_quat = transform.basis.get_rotation_quaternion()
	var new_quat = current_quat.slerp(target_rotation, delta * SPEED)
	transform.basis = Basis(new_quat)


func rotate_left() -> void:
	target_rotation = Quaternion(Vector3.UP, deg_to_rad(-STEP)) * target_rotation
	var euler = target_rotation.get_euler()
	rot_index -= 1
	if rot_index < 0:
		rot_index = 3
	print("Container Y rot: " + str(rad_to_deg(euler.y)))
	emit_signal("rotated", rot_index)


func rotate_right() -> void:
	target_rotation = Quaternion(Vector3.UP, deg_to_rad(STEP)) * target_rotation
	var euler = target_rotation.get_euler()
	rot_index += 1
	if rot_index > 3:
		rot_index = 0
	print("Container Y rot: " + str(rad_to_deg(euler.y)))
	emit_signal("rotated", rot_index)
