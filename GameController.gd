class_name GameController
extends Node3D

const LEVELS = [
	{
		"name": "Level 1",
		"targets": [
			{
				"pos": "(0.0, 0.0, 0.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			}
		]
	},
	{
		"name": "Level name here",
		"targets": [
			{
				"pos": "(-3.0, 0.0, -3.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			},
			{
				"pos": "(3.0, 0.0, 3.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			}
		]
	},
	{
		"name": "Level name here",
		"targets": [
			{
				"pos": "(2.5, 0.0, 0.0)",
				"rot": "(-0.146446, 0.853554, -0.353553, 0.353553)"
			},
			{
				"pos": "(0.0, 0.0, 0.0)",
				"rot": "(-0.0, 1, 0.0, -0.0)"
			}
		],
		"container_rot_index": 1
	},
	{
		"name": "Level name here",
		"targets": [
			{
				"pos": "(0.0, 1.0, -1.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			},
			{
				"pos": "(0.0, -1.0, 1.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			},
			{
				"pos": "(0.0, 0.0, 0.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			}
		],
		"container_rot_index": 3
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
	
	$Cubes.rotated.connect(self.container_rotated)
	
	if find_child("Editor") != null:
		$CanvasLayer/Control/TextureRect.visible = false
		$Cubes.enable_rotation()
		$Cubes.slerping = true
	else:
		load_level(0)


func container_rotated(rot_index: int) -> void:
	for cube in $Cubes.get_children():
		cube.container_rot_index = rot_index
	$CanvasLayer/UI/HBoxContainer/VBoxContainer/RotIndexLabel.text = "Rot index: " + str(rot_index)
	
	var level_complete = check_if_level_complete()
	print("Level complete? " + str(level_complete))
	
	if level_complete and find_child("Editor") == null:
		change_level()


func load_level(level: int) -> void:
	$Cubes.slerping = false
	current_level = level
	
	for cube in $Cubes.get_children():
		$Cubes.remove_child(cube)
		cube.queue_free()
	
	cube_targets.clear()
	cube_states.clear()
	
	var data = LEVELS[current_level]
	print("Level name: " + str(data["name"]))
	
	var has_rot_index = data.has("container_rot_index")
	print("Allow rotation of container? " + str(has_rot_index))
	if has_rot_index == true:
		$Cubes.enable_rotation()
	else:
		$Cubes.disable_rotation()
	$Cubes.rot_index = 0
	$Cubes.target_rotation = Quaternion.IDENTITY
	
	var targets = data["targets"]
	print("Target object count: " + str(targets.size()))
	for target in targets:
		var pos_str: String = str(target["pos"]).trim_prefix("(").trim_suffix(")")
		var pos_parts = pos_str.split(", ")
		var pos = Vector3(float(pos_parts[0]), float(pos_parts[1]), float(pos_parts[2]))
		print("pos: " + str(pos))
		
		var target_str: String = str(target["rot"]).trim_prefix("(").trim_suffix(")")
		var parts = target_str.split(", ")
		var quat = Quaternion(float(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]))
		cube_targets.append(quat)
		print("Solution: " + str(quat))
		
		var cube = cube_scene.instantiate() as RotateScript
		cube.position = pos
		cube.solution = quat
		cube.container_rot_index = 0
		cube.rotated.connect(self.cube_rotated)
		cube.clicked.connect(self.cube_clicked)
		$Cubes.add_child(cube)
		cube_states.append(false)
	
	render_solution(int(data.get("container_rot_index", 0)))
	
	if find_child("Editor") == null:
		$Cubes.rotation.x = 0.0
		$Cubes.rotation.y = -PI * 1.5
		$Cubes.scale = Vector3(0, 0, 0)
		
		var timer = get_tree().create_timer(2.0)
		await timer.timeout
		
		var tween = create_tween()
		tween.tween_property($Cubes, "rotation:y", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		tween.parallel()
		tween.tween_property($Cubes, "scale", Vector3(1, 1, 1), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		tween.parallel()
		tween.tween_property($CanvasLayer/UI/HBoxContainer/VBoxContainer/MarginContainer, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
		
		await tween.finished
	$Cubes.slerping = true


func add_new_cube() -> void:
	var cube = cube_scene.instantiate() as RotateScript
	cube.position = Vector3(0, 0, 0)
	$Cubes.add_child(cube)
	cube.rotated.connect(self.cube_rotated)
	cube.clicked.connect(self.cube_clicked)
	cube_clicked(cube)
	cube_targets.append(Quaternion.IDENTITY)
	cube_states.append(false)


func remove_selected_cube() -> void:
	if current_selection >= 0:
		var cube = $Cubes.get_child(current_selection)
		$Cubes.remove_child(cube)
		cube.queue_free()
		current_selection = -1


func render_solution(rot_index: int) -> void:
	$SubViewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	var container = $SubViewport/SubRoot/Cubes as Node3D
	container.rotation.y = rot_index * deg_to_rad(90)
	
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	
	var data = LEVELS[current_level]
	var targets = data["targets"]
	for target in targets:
		var pos_str: String = str(target["pos"]).trim_prefix("(").trim_suffix(")")
		var pos_parts = pos_str.split(", ")
		var pos = Vector3(float(pos_parts[0]), float(pos_parts[1]), float(pos_parts[2]))
		
		var target_str: String = str(target["rot"]).trim_prefix("(").trim_suffix(")")
		var parts = target_str.split(", ")
		var quat = Quaternion(float(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]))
		
		var cube = cube_scene.instantiate() as RotateScript
		cube.position = pos
		cube.rotation = quat.get_euler()
		container.add_child(cube)


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
	
	if level_complete and find_child("Editor") == null:
		change_level()


func change_level() -> void:
	unselect()
	
	var t0 = get_tree().create_timer(1.5)
	await t0.timeout
	
	for cube in $Cubes.get_children():
		cube.stop_slerp()
	
	var pre_tween = create_tween()
	pre_tween.set_parallel()
	pre_tween.tween_property($Cubes, "rotation:x", PI / 4.0, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	pre_tween.tween_property($CanvasLayer/UI/HBoxContainer/VBoxContainer/MarginContainer, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE)
	await pre_tween.finished
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($Cubes, "rotation:y", PI, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Cubes, "scale", Vector3(0, 0, 0), 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	for cube in $Cubes.get_children():
		tween.tween_property(cube, "rotation:y", cube.rotation.y - PI * 2, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(cube, "scale", Vector3(0, 0, 0), 2.0)
	
	await tween.finished
	
	for cube in $Cubes.get_children():
		cube.visible = false
	
	var timer = get_tree().create_timer(1.0)
	await timer.timeout
	
	# $Cubes.rotation.y = 0.0
	# $Cubes.scale = Vector3(1, 1, 1)
	if current_level < LEVELS.size() - 1:
		load_level(current_level + 1)
	else:
		print("All levels completed!")
	


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cycle_selection"):
		current_selection += 1
		if current_selection >= $Cubes.get_child_count():
			current_selection = 0
		cube_clicked($Cubes.get_children().get(current_selection))
	elif Input.is_action_just_pressed("clear_selection"):
		unselect()
	
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


func unselect() -> void:
	current_selection = -1
	
	var tween = create_tween()
	tween.tween_property(selection_sprite, "modulate:a", 0.0, 0.3)


func check_if_level_complete() -> bool:
	for state in cube_states:
		if state == false:
			return false
	
	var data = LEVELS[current_level]
	return $Cubes.rot_index == int(LEVELS[current_level].get("container_rot_index", 0))


func is_correct(cube: RotateScript) -> bool:
	var index = cube.get_index()
	var target = cube_targets[index] as Quaternion
	var quat = cube.target_rotation
	
	return quat.is_equal_approx(target)


func print_level() -> void:
	var o = {}
	o["name"] = "Level name here"
	o["targets"] = []
	for cube in $Cubes.get_children():
		if cube is Node3D:
			var c = {}
			c["pos"] = str(cube.position)
			c["rot"] = str(cube.transform.basis.get_rotation_quaternion())
			o["targets"].append(c)
	
	o["container_rot_index"] = $Cubes.rot_index
	print(str(o))
