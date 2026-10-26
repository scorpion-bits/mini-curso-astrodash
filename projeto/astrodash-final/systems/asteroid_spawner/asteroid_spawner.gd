class_name AsteroidSpawner
extends Node2D
## Cria asteroides em volta da tela, cruzando a tela em direções aleatórias.
## A dificuldade sobe com o tempo seguindo a curva do Inspector.


@export var asteroid_scene: PackedScene
## Chance (0 a 1) de um asteroide vir mirando direto no player.
@export_range(0.0, 1.0) var aim_at_player_chance: float = 0.3

@export_group("Dificuldade")
## Tempo (em segundos) até chegar na dificuldade máxima.
@export var time_to_max_difficulty: float = 90.0
## X = progresso do tempo (0 a 1), Y = dificuldade (0 a 1).
@export var difficulty_curve: Curve
@export var start_interval: float = 1.0
@export var end_interval: float = 0.2
@export var start_speed_multiplier: float = 1.0
@export var end_speed_multiplier: float = 2.5

var speed_multiplier: float = 1.0

@onready var spawn_point: PathFollow2D = $SpawnPath/SpawnPoint
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	GameManager.game_over.connect(spawn_timer.stop)


func _on_spawn_timer_timeout() -> void:
	_update_difficulty()

	spawn_point.progress_ratio = randf()
	var asteroid: Asteroid = asteroid_scene.instantiate()
	add_child(asteroid)
	asteroid.global_position = spawn_point.global_position

	var target := _pick_target()
	asteroid.launch(asteroid.global_position.direction_to(target), speed_multiplier)


func _update_difficulty() -> void:
	var progress := clampf(GameManager.time_survived / time_to_max_difficulty, 0.0, 1.0)
	var difficulty := difficulty_curve.sample(progress) if difficulty_curve else progress
	spawn_timer.wait_time = lerpf(start_interval, end_interval, difficulty)
	speed_multiplier = lerpf(start_speed_multiplier, end_speed_multiplier, difficulty)


## Escolhe para onde o asteroide vai: às vezes no player, senão um ponto qualquer da tela.
func _pick_target() -> Vector2:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player and randf() < aim_at_player_chance:
		return player.global_position
	var screen := get_viewport_rect().size
	return Vector2(randf_range(0, screen.x), randf_range(0, screen.y))
