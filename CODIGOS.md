# Códigos do mini curso AstroDash

Todos os scripts, na ordem em que aparecem nas aulas. Cada um mostra o caminho onde o arquivo fica no projeto.

> Na Aula 2, `player.gd` e `asteroid_spawner.gd` substituem as versões da Aula 1. `asteroid.gd` não muda.

## Aula 1

### `res://entities/player/player.gd`

```gdscript
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
```

### `res://entities/asteroid/asteroid.gd`

```gdscript
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
```

### `res://systems/asteroid_spawner/asteroid_spawner.gd`

```gdscript
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
```

## Aula 2 (versões finais)

### `res://autoload/game_manager.gd`

```gdscript
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
```

### `res://levels/game/game.gd`

```gdscript
extends Node2D


func _ready() -> void:
	GameManager.start_game()
```

### `res://ui/hud/hud.gd`

```gdscript
extends CanvasLayer


@onready var time_label: Label = %TimeLabel
@onready var best_label: Label = %BestLabel


func _ready() -> void:
	best_label.text = "Recorde: %.1f s" % GameManager.best_time


func _process(_delta: float) -> void:
	time_label.text = "Tempo: %.1f s" % GameManager.time_survived
```

### `res://components/health_component.gd`

```gdscript
class_name HealthComponent
extends Node
## Componente de vida: guarda a vida de quem for "dono" dele e avisa quando morrer.
## Pode ser usado no player, em inimigos, em chefões...


## Emitido sempre que a vida muda (útil para barras de vida e corações).
signal health_changed(current: int, maximum: int)
## Emitido quando a vida chega a zero.
signal died

@export var max_health: int = 1

var current_health: int


func _ready() -> void:
	current_health = max_health


func take_damage(amount: int) -> void:
	if current_health <= 0:
		return
	current_health = maxi(current_health - amount, 0)
	health_changed.emit(current_health, max_health)
	if current_health == 0:
		died.emit()


func heal(amount: int) -> void:
	current_health = mini(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)
```

### `res://components/hurtbox_component.gd`

```gdscript
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
```

### `res://entities/player/player.gd`

```gdscript
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
```

### `res://ui/game_over/game_over.gd`

```gdscript
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
```

### `res://ui/main_menu/main_menu.gd`

```gdscript
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
```

### `res://systems/asteroid_spawner/asteroid_spawner.gd`

```gdscript
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
```
