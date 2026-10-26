class_name AsteroidSpawner
extends Node2D
## Cria asteroides em volta da tela, cruzando a tela em direções aleatórias.


@export var asteroid_scene: PackedScene

@onready var spawn_point: PathFollow2D = $SpawnPath/SpawnPoint


func _on_spawn_timer_timeout() -> void:
	spawn_point.progress_ratio = randf()
	var asteroid: Asteroid = asteroid_scene.instantiate()
	add_child(asteroid)
	asteroid.global_position = spawn_point.global_position

	var target := _pick_target()
	asteroid.launch(asteroid.global_position.direction_to(target))


## Escolhe um ponto qualquer da tela para o asteroide atravessar.
func _pick_target() -> Vector2:
	var screen := get_viewport_rect().size
	return Vector2(randf_range(0, screen.x), randf_range(0, screen.y))
