extends Control


@onready var best_label: Label = %BestLabel
@onready var play_button: Button = %PlayButton


func _ready() -> void:
	best_label.text = "Recorde: %.1f s" % GameManager.best_time
	play_button.grab_focus()


func _on_play_button_pressed() -> void:
	GameManager.go_to_game()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
