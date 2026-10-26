extends CanvasLayer


@onready var time_label: Label = %TimeLabel
@onready var best_label: Label = %BestLabel


func _ready() -> void:
	best_label.text = "Recorde: %.1f s" % GameManager.best_time


func _process(_delta: float) -> void:
	time_label.text = "Tempo: %.1f s" % GameManager.time_survived
