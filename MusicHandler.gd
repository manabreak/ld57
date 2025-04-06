extends Node


func _ready() -> void:
	$BGMusicIntro.finished.connect(self.on_intro_finished)
	$BGMusicLoop.finished.connect(self.on_intro_finished)
	$BGMusicIntro.play()


func on_intro_finished() -> void:
	$BGMusicLoop.play()
