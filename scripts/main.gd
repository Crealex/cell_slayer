extends Node2D

@export var player_scene: PackedScene  
@export var enemy_scene: PackedScene 
@export var enemy_spawn_radius: float = 300.0  
@export var map_scene: PackedScene
@export var menu_scene: PackedScene
@export var menu_Help: PackedScene
@export var menu_logo: PackedScene
@export var hud_scene: PackedScene

var player
var map
var menu
var help
var hud

func _ready():
	menu = menu_scene.instantiate()
	add_child(menu)
	menu.main_scene = self  # ✅ Assigne `self` au menu

	help = menu_Help.instantiate()
	add_child(help)
	help.hide()  # ✅ Cache le menu d'aide au démarrage

	map = map_scene.instantiate()
	add_child(map)
	create_timer(1.0)

func start_game():
	map = map_scene.instantiate()
	add_child(map)
	map.show()
	
	if hud_scene:
		hud = hud_scene.instantiate()
		add_child(hud)

	spawn_player()
	create_timer(1.0)

func spawn_player():
	if player_scene:
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = get_viewport_rect().size / 2  

func spawn_enemies(val):
	var enemy = enemy_scene.instantiate()

	if player != null:
		var player_pos = player.global_position
		var angle = randf_range(0, 2 * PI)
		var spawn_pos = player_pos + Vector2(enemy_spawn_radius * cos(angle), enemy_spawn_radius * sin(angle))
		enemy.global_position = spawn_pos
	else:
		enemy.global_position = Vector2(randf_range(0, 600), randf_range(100, 400))

	if val == 0:
		enemy.init_enemy(0, 3)
	elif val == 1:
		enemy.init_enemy(1, 2)

	get_tree().root.call_deferred("add_child", enemy)

func create_timer(wait_time: float):
	var timer = Timer.new()
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.timeout.connect(self.callback)
	add_child(timer)
	timer.start()
	
func callback():
	var random_number = randf_range(1.0, 2.0)
	create_timer(random_number)
	spawn_enemies(randi() % 2)

func play_button():
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = $Son_bouton.stream
	sound_player.bus = "Pop"
	
	get_tree().root.add_child(sound_player)
	sound_player.play()
	
	sound_player.finished.connect(func(): sound_player.queue_free())
