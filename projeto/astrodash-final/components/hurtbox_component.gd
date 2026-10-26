class_name HurtboxComponent
extends Area2D
## Componente "área de dano": quando um corpo perigoso encosta nele,
## tira vida do HealthComponent ligado no Inspector.


@export var health_component: HealthComponent
@export var damage_per_hit: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D) -> void:
	health_component.take_damage(damage_per_hit)
