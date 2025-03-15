extends Node2D

@export var player_scene: PackedScene  # Scène du joueur
@export var enemy_scene: PackedScene 
@export var enemy_spawn_radius: float = 300.0  # Rayon autour du joueur où spawn les ennemis
@export var map_scene: PackedScene
@export var menu_scene:PackedScene
@export var menu_Help:PackedScene
@export var menu_logo:PackedScene
@export var hud_scene:PackedScene

var player  # Référence au joueur
var map
var menu
var hud

func _ready():

	menu = menu_scene.instantiate()
	add_child(menu)
	menu.main_scene = self
	#

func start_game():
	map = map_scene.instantiate()
	add_child(map)
	map.init_map()
	hud = hud_scene.instantiate()
	add_child(hud)
	spawn_player()
	create_timer(1.0)
	
func spawn_player():
	if player_scene:
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = get_viewport_rect().size / 2  # Centre le joueur

func spawn_enemies(val):
	var enemy = enemy_scene.instantiate()  # Instancie un ennemi

	if player != null:
		var player_pos = player.global_position  # Position du joueur


		var angle = randf_range(0, 2 * PI)
		var spawn_pos = player_pos + Vector2(enemy_spawn_radius * cos(angle), enemy_spawn_radius * sin(angle))
		enemy.global_position = spawn_pos
	else:
		enemy.global_position = Vector2(randf_range(0, 600), randf_range(100, 400))
		
		
	if val == 0:
		enemy.init_enemy(0, 3)
	elif val == 1:
		enemy.init_enemy(1, 2)
	get_tree().root.call_deferred("add_child", enemy)  # ✅ Ajout sécurisé à la scène

func create_timer(wait_time: float):
	var timer = Timer.new()  # Crée un Timer
	timer.wait_time = wait_time  # Définit le temps d'attente
	timer.one_shot = true  # Pour qu'il ne se répète pas automatiqueAment
	timer.timeout.connect(self.callback)  # Connecte la fonction à appeler après le temps écoulé
	add_child(timer)  # Ajoute le Timer à la scène
	timer.start()  # Démarre le Timer
	
func callback():
	var min_value = 1.0
	var max_value = 2.0
	var random_number = randf() * (max_value - min_value) + min_value
	create_timer(random_number)
	#spawn_enemies(0)
	spawn_enemies(randi()%2)
