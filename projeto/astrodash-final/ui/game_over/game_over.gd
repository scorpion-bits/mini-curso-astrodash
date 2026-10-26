extends CanvasLayer


@onready var result_label: Label = %ResultLabel
@onready var restart_button: Button = %RestartButton
@onready var show_delay: Timer = $ShowDelay


func _ready() -> void:
	hide()
	GameManager.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	# Espera um pouquinho para dar tempo de ver a explosão.
	show_delay.start()


func _on_show_delay_timeout() -> void:
	var text := "Você sobreviveu %.1f s\nRecorde: %.1f s"
	result_label.text = text % [GameManager.time_survived, GameManager.best_time]
	show()
	restart_button.grab_focus()


func _on_restart_button_pressed() -> void:
	GameManager.go_to_game()


func _on_menu_button_pressed() -> void:
	GameManager.go_to_menu()
