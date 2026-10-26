class_name Player
extends CharacterBody2D


## Velocidade máxima da nave (pixels por segundo).
@export var speed: float = 180.0
## Quão rápido a nave acelera e freia.
@export var acceleration: float = 900.0
## Quão rápido a nave gira para a direção do movimento.
@export var rotation_speed: float = 10.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var death_particles: CPUParticles2D = $DeathParticles


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(direction * speed, acceleration * delta)
	move_and_slide()

	if direction != Vector2.ZERO:
		rotation = lerp_angle(rotation, direction.angle(), rotation_speed * delta)


func _on_health_component_died() -> void:
	set_physics_process(false)
	sprite.hide()
	death_particles.emitting = true
	GameManager.end_game()
