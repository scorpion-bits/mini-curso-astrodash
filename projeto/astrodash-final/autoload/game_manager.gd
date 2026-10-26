extends Node
## GameManager (Autoload): guarda o estado da partida e o recorde.
## Qualquer script do jogo pode acessar com GameManager.alguma_coisa


## Avisa que uma partida nova começou.
signal game_started
## Avisa que o jogador morreu e a partida acabou.
signal game_over

const GAME_SCENE := "res://levels/game/game.tscn"
const MENU_SCENE := "res://ui/main_menu/main_menu.tscn"
const SAVE_PATH := "user://save.cfg"

var time_survived: float = 0.0
var best_time: float = 0.0
var is_playing: bool = false


func _ready() -> void:
	load_best_time()


func _process(delta: float) -> void:
	if is_playing:
		time_survived += delta


func start_game() -> void:
	time_survived = 0.0
	is_playing = true
	game_started.emit()


func end_game() -> void:
	if not is_playing:
		return
	is_playing = false
	if time_survived > best_time:
		best_time = time_survived
		save_best_time()
	game_over.emit()


func go_to_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)


func go_to_menu() -> void:
	is_playing = false
	get_tree().change_scene_to_file(MENU_SCENE)


func save_best_time() -> void:
	var config := ConfigFile.new()
	config.set_value("score", "best_time", best_time)
	config.save(SAVE_PATH)


func load_best_time() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		best_time = config.get_value("score", "best_time", 0.0)
