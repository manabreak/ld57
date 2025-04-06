extends Node3D

@export
var add_button: Button

@export
var add_cylinder_button: Button

@export
var add_cone_button: Button

@export
var remove_button: Button

@export
var print_button: Button

var controller: GameController

func _ready() -> void:
	controller = get_parent() as GameController
	add_button.pressed.connect(self.add_pressed)
	add_cylinder_button.pressed.connect(self.add_cylinder_pressed)
	add_cone_button.pressed.connect(self.add_cone_pressed)
	remove_button.pressed.connect(self.remove_pressed)
	print_button.pressed.connect(self.print_pressed)


func add_pressed() -> void:
	controller.add_new_cube()


func add_cylinder_pressed() -> void:
	controller.add_new_cylinder()


func add_cone_pressed() -> void:
	controller.add_new_cone()


func remove_pressed() -> void:
	controller.remove_selected_cube()


func print_pressed() -> void:
	controller.print_level()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("print_level"):
		controller.print_level()
