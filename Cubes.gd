class_name Cubes
extends Node3D

const SPEED = 5.0
const STEP = 90.0


@export
var start_orientation: Vector3

signal rotated(Cubes)

## The correct solution orientation
var solution: Quaternion = Quaternion.IDENTITY

## Slerp target
var target_rotation: Quaternion = Quaternion.IDENTITY

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("container_left"):
		rotate_left()
		debug_print()
	elif Input.is_action_just_pressed("container_right"):
		rotate_right()
		debug_print()


func debug_print():
	# print("- Orientation now: " + str(target_rotation))
	# print("- Solution: " + str(solution))
	
	var target_euler = target_rotation.get_euler()
	var solution_euler = solution.get_euler()
	# print("- Orientation euler: " + str(target_euler))
	# print("- Solution euler: " + str(solution_euler))
	
	var angles = Vector3(rad_to_deg(target_euler.x), rad_to_deg(target_euler.y), rad_to_deg(target_euler.z))
	# print("Target angles: " + str(angles))
	


func _physics_process(delta: float) -> void:
	var current_quat = transform.basis.get_rotation_quaternion()
	var new_quat = current_quat.slerp(target_rotation, delta * SPEED)
	transform.basis = Basis(new_quat)


func rotate_down() -> void:
	# print("Rotate down")
	target_rotation = Quaternion(Vector3.RIGHT, deg_to_rad(STEP)) * target_rotation
	emit_signal("rotated", self)


func rotate_up() -> void:
	# print("Rotate up")
	target_rotation = Quaternion(Vector3.RIGHT, deg_to_rad(-STEP)) * target_rotation
	emit_signal("rotated", self)


func rotate_left() -> void:
	# print("Rotate left")
	target_rotation = Quaternion(Vector3.UP, deg_to_rad(-STEP)) * target_rotation
	emit_signal("rotated", self)


func rotate_right() -> void:
	# print("Rotate right")
	target_rotation = Quaternion(Vector3.UP, deg_to_rad(STEP)) * target_rotation
	emit_signal("rotated", self)
