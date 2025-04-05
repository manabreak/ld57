extends Node3D

const LEVELS = [
	{
		"name": "Level 1",
		"targets": [
			{
				"rot": "0.353553, 0.353553, 0.146447, 0.853553"
			}
		]
	}
]

@export
var cube_scene: PackedScene

var current_level: int = 0

var cube_targets = []
var cube_states = []

func _ready() -> void:
	load_level(0)
	# $TestCube.solution = Quaternion(Vector3.RIGHT, deg_to_rad(45.0)) * Quaternion(Vector3.UP, deg_to_rad(45.0))


func load_level(level: int) -> void:
	current_level = level
	cube_targets.clear()
	cube_states.clear()
	
	var data = LEVELS[current_level]
	print("Level name: " + str(data["name"]))
	
	var targets = data["targets"]
	print("Target object count: " + str(targets.size()))
	for target in targets:
		var target_str: String = str(target["rot"])
		var parts = target_str.split(", ")
		var quat = Quaternion(float(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]))
		cube_targets.append(quat)
		print("Solution: " + str(quat))
		
		var cube = cube_scene.instantiate() as RotateScript
		cube.solution = quat
		cube.rotated.connect(self.cube_rotated)
		$Cubes.add_child(cube)
		cube_states.append(false)


func cube_rotated(cube: RotateScript) -> void:
	print("Cube is now rotated to: " + str(cube.target_rotation) + " and its goal is " + str(cube.solution))
	
	var index = cube.get_index()
	print("Cube index: " + str(index))
	
	var target = cube_targets[index]
	print("Target: " + str(target))
	
	print("Is correct? " + str(is_correct(cube)))
	cube_states[index] = is_correct(cube)
	
	var level_complete = check_if_level_complete()
	print("Level complete? " + str(level_complete))


func check_if_level_complete() -> bool:
	for state in cube_states:
		if state == false:
			return false
	return true


func is_correct(cube: RotateScript) -> bool:
	var index = cube.get_index()
	var target = cube_targets[index] as Quaternion
	var quat = cube.target_rotation
	
	return quat.is_equal_approx(target)
