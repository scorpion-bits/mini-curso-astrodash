class_name Asteroid
extends RigidBody2D


@export var min_speed: float = 60.0
@export var max_speed: float = 120.0
## Velocidade máxima de giro (radianos por segundo).
@export var max_spin: float = 3.0


## Lança o asteroide em uma direção. Quem chama é o AsteroidSpawner.
func launch(direction: Vector2, speed_multiplier: float = 1.0) -> void:
	linear_velocity = direction * randf_range(min_speed, max_speed) * speed_multiplier
	angular_velocity = randf_range(-max_spin, max_spin)
