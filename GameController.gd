class_name GameController
extends Node3D

const LEVELS = [
	{
		"targets": [
			{
				"type": "cube",
				"pos": "(0.0, 0.0, 0.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			}
		]
	},
	{
		"targets": [
			{
				"type": "cube",
				"pos": "(-3.0, 0.0, -3.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			},
			{
				"type": "cube",
				"pos": "(3.0, 0.0, 3.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			}
		]
	},
	{
		"targets": [
			{
				"type": "cube",
				"pos": "(2.5, 0.0, 0.0)",
				"rot": "(-0.146446, 0.853554, -0.353553, 0.353553)"
			},
			{
				"type": "cube",
				"pos": "(0.0, 0.0, 0.0)",
				"rot": "(-0.0, 1, 0.0, -0.0)"
			}
		],
		"container_rot_index": 1
	},
	{
		"targets": [
			{
				"type": "cube",
				"pos": "(0.0, 1.0, -1.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			},
			{
				"type": "cube",
				"pos": "(0.0, -1.0, 1.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			},
			{
				"type": "cube",
				"pos": "(0.0, 0.0, 0.0)",
				"rot": "(0.353553, 0.353553, 0.146447, 0.853553)"
			}
		],
		"container_rot_index": 3
	},
	{ "targets": [{ "type": "cube", "pos": "(1.5, 1.5, 0.0)", "rot": "(0.0, 0.92388, -0.0, 0.382683)" }, { "type": "cube", "pos": "(0.0, 0.0, 0.0)", "rot": "(0.653282, 0.653281, 0.270598, 0.270598)" }, { "type": "cube", "pos": "(-1.5, -1.5, 1.5)", "rot": "(0.923879, 0.0, 0.382684, 0.0)" }], "container_rot_index": 1 },
	{ "targets": [{ "type": "cylinder", "pos": "(1.5, 0.0, 0.0)", "rot": "(0.270598, -0.653282, -0.270598, 0.653281)" }, { "type": "cube", "pos": "(-1.5, 0.0, 0.0)", "rot": "(0.270598, -0.653282, -0.270598, 0.653281)" }, { "type": "cube", "pos": "(0.0, 0.0, 0.0)", "rot": "(-0.270598, 0.653282, -0.270598, 0.653282)" }], "container_rot_index": 0 },
	{ "targets": [{ "type": "cylinder", "pos": "(1.5, 2.0, 1.5)", "rot": "(-0.0, -0.0, -0.707107, 0.707107)" }, { "type": "cube", "pos": "(-1.5, -2.0, 0.0)", "rot": "(0.5, -0.5, -0.5, 0.5)" }, { "type": "cube", "pos": "(0.0, 0.0, -1.5)", "rot": "(0.853554, -0.146446, -0.353553, -0.353553)" }], "container_rot_index": 3 }
]

@export
var selection_sprite: Sprite2D

@export
var cube_scene: PackedScene

@export
var cylinder_scene: PackedScene

@export
var main_ui: Control

@export
var title_label: Label

@export
var desc_label: Label

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
		start_script_seq()
		# load_level(0)


func start_script_seq() -> void:
	main_ui.modulate.a = 0.0
	title_label.text = ""
	desc_label.text = ""
	
	await pause(2.0)
	
	## First message
	
	title_label.visible_ratio = 0.0
	title_label.text = "//ASSESSMENT/LD57/HUMAN_42069/INIT"
	
	var tween = create_tween()
	tween.tween_property(title_label, "visible_ratio", 1.0, 2.0)
	
	await tween.finished
	await pause(1.0)
	
	await show_message("Welcome, initiate LD57/HUMAN_42069.\nToday, you are participating in our\nneural conditioning program, or NCP for short.")
	await pause(2.0)
	await show_message("During NCP, your capabilities concerning depth perception are analyzed.\nAll adequately performing individuals will be rewarded.")
	await pause(2.0)
	await show_message("It is expected that approximately 57% of participants will fail the assessment.\nAll failures will go on your permanent record.")
	await pause(2.0)
	await show_message("Beginning baseline calibration...", 3.0)
	await pause(2.0)
	
	tween = create_tween()
	tween.tween_property(main_ui, "modulate:a", 1.0, 3.0).set_trans(Tween.TRANS_SPRING)
	await tween.finished
	
	await show_message("Baseline calibrated.\nLoading assessments and relevant instructions...", 4.0)
	load_level(0)
	await pause(2.0)
	await show_message("Note: If you require assistance, refer to your employee manual.\nYou have received your manual during your orientation.")
	await pause(2.0)
	await show_message("If you do not have your employee manual,\nreport to the sanctioning committee immediately.")
	await pause(2.0)
	await show_message("Your assignments are shown on the left side of the screen.\nTo pass an assignment, manipulate the view on the right side\nto match the assignment.")
	await pause(2.0)
	await show_message("Use mouse to select an object.\nUse W/A/S/D or arrow keys to manipulate the object.")
	await pause(2.0)


func pause(time: float) -> Signal:
	return get_tree().create_timer(time).timeout


func show_message(text: String, time: float = 8.0) -> Signal:
	desc_label.visible_ratio = 0.0
	desc_label.text = text
	var tween = create_tween()
	tween.tween_property(desc_label, "visible_ratio", 1.0, time)
	return tween.finished


func show_level_completion_message() -> Signal:
	match current_level:
		0:
			await show_message("Completing the first task took you\n48% longer compared to an average individual.\nThis performance will be logged.")
			await pause(2.0)
			return show_message("Proceed with the next assignment.\nYou can use TAB key to cycle the selections.", 5.0)
		1:
			await show_message("Your relative performance seemed to slightly improve.", 4.0)
			await pause(2.0)
			await show_message("The next assignment requires you to manipulate\nall objects at the same time.\nUse Q and E keys to perform this.")
			await pause(2.0)
			return show_message("When you have finished the manipulation,\nset your view to match the 'front' view.")
		2:
			await show_message("Recalibrating baseline...", 2.0)
			await pause(2.0)
			return show_message("Baseline recalibrated.\nProceed with the next assignment.", 4.0)
		3:
			await show_message("Improved depth perception capabilities recognized.\nIncreasing assessment difficulty...")
			await pause(2.0)
			return show_message("Employee capability class increased.\nPrevious class: F. Current class: D.")
		4:
			return show_message("Introducing new shape.\nEmployee heart rate seems to be slightly elevated.", 5.0)
		5:
			await show_message("LD57/HUMAN_42069 recognized the new shape.", 2.0)
			await pause(2.0)
			return show_message("Interesting. Proceeding with the assessment.", 2.0)
	return get_tree().create_timer(0.1).timeout


func container_rotated(rot_index: int) -> void:
	for cube in $Cubes.get_children():
		cube.container_rot_index = rot_index
	
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
		var type: String = str(target.get("type", "cube"))
		
		var pos_str: String = str(target["pos"]).trim_prefix("(").trim_suffix(")")
		var pos_parts = pos_str.split(", ")
		var pos = Vector3(float(pos_parts[0]), float(pos_parts[1]), float(pos_parts[2]))
		print("pos: " + str(pos))
		
		var target_str: String = str(target["rot"]).trim_prefix("(").trim_suffix(")")
		var parts = target_str.split(", ")
		var quat = Quaternion(float(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]))
		cube_targets.append(quat)
		print("Solution: " + str(quat))
		
		var cube: RotateScript = null
		if type == "cube":
			cube = cube_scene.instantiate() as RotateScript
		elif type == "cylinder":
			cube = cylinder_scene.instantiate() as RotateScript
		cube.position = pos
		cube.solution = quat
		cube.container_rot_index = 0
		cube.rotated.connect(self.cube_rotated)
		cube.clicked.connect(self.cube_clicked)
		$Cubes.add_child(cube)
		cube_states.append(false)
	
	render_solution_front(int(data.get("container_rot_index", 0)))
	render_solution_right(int(data.get("container_rot_index", 0)))
	
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
		tween.tween_property($CanvasLayer/UI/HBoxContainer/VBoxContainer/MarginContainer2, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
		
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


func add_new_cylinder() -> void:
	var cube = cylinder_scene.instantiate() as RotateScript
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


func render_solution_front(rot_index: int) -> void:
	$SubViewportFront.render_target_update_mode = SubViewport.UPDATE_ONCE
	var container = $SubViewportFront/SubRoot/Cubes as Node3D
	container.rotation.y = rot_index * deg_to_rad(90)
	
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	
	var data = LEVELS[current_level]
	var targets = data["targets"]
	for target in targets:
		var type = str(target.get("type", "cube"))
		var pos_str: String = str(target["pos"]).trim_prefix("(").trim_suffix(")")
		var pos_parts = pos_str.split(", ")
		var pos = Vector3(float(pos_parts[0]), float(pos_parts[1]), float(pos_parts[2]))
		
		var target_str: String = str(target["rot"]).trim_prefix("(").trim_suffix(")")
		var parts = target_str.split(", ")
		var quat = Quaternion(float(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]))
		
		var cube: RotateScript = null
		if type == "cylinder":
			cube = cylinder_scene.instantiate() as RotateScript
		else:
			cube = cube_scene.instantiate() as RotateScript
		
		cube.position = pos
		cube.rotation = quat.get_euler()
		container.add_child(cube)


func render_solution_right(rot_index: int) -> void:
	$SubViewportRight.render_target_update_mode = SubViewport.UPDATE_ONCE
	var container = $SubViewportRight/SubRoot/Cubes as Node3D
	container.rotation.y = rot_index * deg_to_rad(90)
	
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	
	var data = LEVELS[current_level]
	var targets = data["targets"]
	for target in targets:
		var type = str(target.get("type", "cube"))
		var pos_str: String = str(target["pos"]).trim_prefix("(").trim_suffix(")")
		var pos_parts = pos_str.split(", ")
		var pos = Vector3(float(pos_parts[0]), float(pos_parts[1]), float(pos_parts[2]))
		
		var target_str: String = str(target["rot"]).trim_prefix("(").trim_suffix(")")
		var parts = target_str.split(", ")
		var quat = Quaternion(float(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]))
		
		var cube: RotateScript = null
		if type == "cylinder":
			cube = cylinder_scene.instantiate() as RotateScript
		else:
			cube = cube_scene.instantiate() as RotateScript
		
		cube.position = pos
		cube.rotation = quat.get_euler()
		container.add_child(cube)


func cube_rotated(cube: RotateScript) -> void:
	var index = cube.get_index()
	var target = cube_targets[index]
	cube_states[index] = is_correct(cube)
	
	var level_complete = check_if_level_complete()
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
	pre_tween.tween_property($CanvasLayer/UI/HBoxContainer/VBoxContainer/MarginContainer2, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE)
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
	
	if current_level < LEVELS.size() - 1:
		await show_level_completion_message()
		load_level(current_level + 1)
	else:
		title_label.visible_ratio = 0.0
		title_label.text = "//ASSESSMENT/LD57/HUMAN_42069/COMPLETE"
		
		var title_end_tween = create_tween()
		title_end_tween.tween_property(title_label, "visible_ratio", 1.0, 2.0)
		
		await show_message("You have performed adequately during your assessment.\nThe results will be used to calibrate your NCP score.")
		await get_tree().create_timer(2.0).timeout
		
		var end_tween = create_tween()
		end_tween.set_parallel()
		end_tween.tween_property(main_ui, "modulate:a", 0.0, 2.0)
		end_tween.tween_property(title_label, "modulate:a", 0.0, 2.2)
		
		await show_message("You are dismissed.\nThank you for your participation.", 4.0)


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
	
	var result = abs(quat.dot(target)) >= 1.0 - 0.001 or quat.is_equal_approx(target) or quat.is_equal_approx(-target)
	if result == false:
		print("Not same; Cube is " + str(quat) + " === target is " + str(target))
	return result


func print_level() -> void:
	var o = {}
	o["targets"] = []
	for cube in $Cubes.get_children():
		if cube is Node3D:
			var c = {}
			if cube.name.begins_with("ColorCylinder"):
				c["type"] = "cylinder"
			else:
				c["type"] = "cube"
			c["pos"] = str(cube.position)
			c["rot"] = str(cube.transform.basis.get_rotation_quaternion())
			o["targets"].append(c)
	
	o["container_rot_index"] = $Cubes.rot_index
	print(str(o))
