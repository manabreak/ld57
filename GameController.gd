extends Node3D

const LEVELS = [
	{
		"name": "Level 1",
		"targets": [
			{
				"pos": "3.0, 0.0, 0.0",
				"rot": "0.353553, 0.353553, 0.146447, 0.853553"
			}
		]
	},
	{
		"name": "Level 2",
		"targets": [
			{
				"pos": "2.0, 0.0, 2.0",
				"rot": "0.353553, 0.353553, 0.146447, 0.853553"
			},
			{
				"pos": "2.0, 0.0, -2.0",
				"rot": "0.353553, 0.353553, 0.146447, 0.853553"
			},
			{
				"pos": "-2.0, 0.0, -2.0",
				"rot": "0.353553, 0.353553, 0.146447, 0.853553"
			}
		]
	}
]

@export
var selection_sprite: Sprite2D

@export
var cube_scene: PackedScene

var current_level: int = 0

var cube_targets = []
var cube_states = []

var current_selection: int = -1

func _ready() -> void:
	selection_sprite.modulate.a = 0.0
	selection_sprite.scale = Vector2(0.6, 0.6)
	
	var scale_tween = create_tween()
	scale_tween.set_loops()
	scale_tween.tween_property(selection_sprite, "scale", Vector2(0.55, 0.55), 1.65).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(selection_sprite, "scale", Vector2(0.65, 0.65), 1.65).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	load_level(1)
	# $TestCube.solution = Quaternion(Vector3.RIGHT, deg_to_rad(45.0)) * Quaternion(Vector3.UP, deg_to_rad(45.0))


func load_level(level: int) -> void:
	current_level = level
	
	for cube in $Cubes.get_children():
		$Cubes.remove_child(cube)
		cube.queue_free()
	
	cube_targets.clear()
	cube_states.clear()
	
	var data = LEVELS[current_level]
	print("Level name: " + str(data["name"]))
	
	var targets = data["targets"]
	print("Target object count: " + str(targets.size()))
	for target in targets:
		var pos_str: String = str(target["pos"])
		var pos_parts = pos_str.split(", ")
		var pos = Vector3(float(pos_parts[0]), float(pos_parts[1]), float(pos_parts[2]))
		print("pos: " + str(pos))
		
		var target_str: String = str(target["rot"])
		var parts = target_str.split(", ")
		var quat = Quaternion(float(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]))
		cube_targets.append(quat)
		print("Solution: " + str(quat))
		
		var cube = cube_scene.instantiate() as RotateScript
		cube.position = pos
		cube.solution = quat
		cube.rotated.connect(self.cube_rotated)
		cube.clicked.connect(self.cube_clicked)
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


func _process(delta: float) -> void:
	if current_selection >= 0:
		var cube = $Cubes.get_child(current_selection)
		var global_pos = cube.global_position
		var screen_pos = $Camera3D.unproject_position(global_pos)
		selection_sprite.position = screen_pos


func cube_clicked(cube: RotateScript) -> void:
	current_selection = cube.get_index()
	
	for c in $Cubes.get_children():
		c.selected = false
	
	cube.selected = true
	
	var tween = create_tween()
	tween.tween_property(selection_sprite, "modulate:a", 0.35, 0.3)


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


func print_level() -> void:
	pass
