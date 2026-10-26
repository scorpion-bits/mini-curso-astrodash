class_name Player
extends CharacterBody2D


## Velocidade máxima da nave (pixels por segundo).
@export var speed: float = 180.0
## Quão rápido a nave acelera e freia.
@export var acceleration: float = 900.0
## Quão rápido a nave gira para a direção do movimento.
@export var rotation_speed: float = 10.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(direction * speed, acceleration * delta)
	move_and_slide()

	if direction != Vector2.ZERO:
		rotation = lerp_angle(rotation, direction.angle(), rotation_speed * delta)
