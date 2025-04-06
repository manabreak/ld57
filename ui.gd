class_name UI
extends Control

@export
var info_value: Label

@export
var classification_value: Label

@export
var score_value: Label

@export
var vitals_value: Label

var classification: String = "F"
var score: int = 0
var target_hr: int = 65

var timer = 0.0


func level_completed(level: int) -> void:
	print("UI: Level completed: " + str(level))
	score += 5
	score_value.text = str(score)
	
	if level < 3:
		classification = "F"
	elif level == 3:
		classification = "D"
	elif level == 8:
		classification = "C"
	elif level == 15:
		classification = "B"
	elif level == 20:
		classification = "B+"
	
	classification_value.text = classification


func _process(delta: float) -> void:
	timer += delta
	while timer >= 1.0:
		timer -= 1.0
		update_hr()


func update_hr() -> void:
	var hr = target_hr + randi_range(-5, 5)
	vitals_value.text = str(hr) + " bpm"
