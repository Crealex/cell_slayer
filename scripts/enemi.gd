extends CharacterBody2D

@export var speed: float = 100.0  # Vitesse de l'ennemi"res://assets/vert2.png"d
@export var enemy_scene: PackedScene  # Référence à cette scène pour division
@export var spritesheet: Texture2D
@export var spritetouch: Texture2D
@export var cytokine: PackedScene

var tile_size = Vector2(16, 16)
var player  # Référence au joueur
var enemi_type
var size_level
var life
var atlas_texture
var blink
var blink_stat
var damage
var one
var random_direction

func init_enemy(type : int, lvl : int) -> void:
	enemi_type = type
	size_level = lvl
	one = true
	update_sprite()

func _ready():
	
	if enemy_scene == null:
		enemy_scene = load("res://scenes/enemi.tscn")
	# Vérifie que l'Area2D est bien trouvée et connecte le signal
	var hitbox = $Area2D  # S'assurer que "Area2D" est bien nommé ainsi
	if hitbox:
		hitbox.area_entered.connect(_on_area_entered)
	
	$Area2D.body_entered.connect(_on_body_entered)
	# Trouver le joueur dans la scène
	player = get_tree().get_first_node_in_group("player")

func _process(delta):

	if player != null:
		var direction = (player.global_position - global_position).normalized()  # Direction vers le joueur
		velocity = direction * speed  # Applique la vitesse
		look_at(player.global_position)  # Oriente l'ennemi vers le joueur
	else:
		if one:
			random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			one = false
		velocity = random_direction * speed  # Déplacement aléatoire
		
	move_and_slide()

func split():
	var ran = 0
	match enemi_type:
		0:
			ran = 2
		1:
			ran = 3
			
	if size_level > 1 and enemy_scene:
		for i in range(ran):  # Crée deux nouveaux ennemis plus petits
			var new_enemy = enemy_scene.instantiate()
			new_enemy.init_enemy(enemi_type, size_level - 1)
			get_parent().call_deferred("add_child", new_enemy)
			new_enemy.global_position = global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))  # Légèrement décalé
			new_enemy.speed *= 1.2 # Augmente légèrement la vitesse
			new_enemy.update_sprite()
			var new_cytokine = cytokine.instantiate()
			get_parent().call_deferred("add_child", new_cytokine)
			new_cytokine.global_position = global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
	
	sound()
	
func sound():
	var sound_player = AudioStreamPlayer.new()  # Crée un nouveau lecteur audio
	sound_player.stream = $AudioStreamPlayer.stream  # Associe le son
	add_child(sound_player)  # Ajoute le lecteur audio à la scène
	sound_player.bus = "Pop"
	sound_player.play()  # Joue le son
	
	# Supprime le son après lecture
	sound_player.finished.connect(func(): sound_player.queue_free())
	queue_free()  # Supprime cet ennemi après division
	
func _on_area_entered(area):
	if area.is_in_group("bullets"):
		if life > 0:
			life -= 1
			blink = 0
			touch()
		else:
			if size_level > 1:
				split()  # Divise en 2 si possible
			else:
				queue_free()

		if is_instance_valid(area):
			area.queue_free()  # Supprime la balle après impact
		
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
		
func update_sprite():
	atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = spritesheet  # Associe l'image complète au `AtlasTexture`
	
	match enemi_type:
		0:#Cell Killer
			if size_level == 3:
				atlas_texture.region = Rect2(0, 0, tile_size.x, tile_size.y)  # Grand ennemi
				$Sprite2D.scale = Vector2(4, 4)
				life = 3
				damage = 20
	
			elif size_level == 2:
				atlas_texture.region = Rect2(16, 0, tile_size.x, tile_size.y)
				$Sprite2D.scale = Vector2(3, 3)
				life = 2
				damage = 10

			elif size_level == 1:
				atlas_texture.region = Rect2(32, 0, tile_size.x, tile_size.y)
				$Sprite2D.scale = Vector2(2.5, 2.5)
				life = 1
				damage = 5

		1:#Microbe
			if size_level == 2:
				atlas_texture.region = Rect2(0, 16, tile_size.x, tile_size.y) 
				$Sprite2D.scale = Vector2(4, 4)
				life = 2
				damage = 20
				
			elif size_level == 1:
				atlas_texture.region = Rect2(16, 16, tile_size.x, tile_size.y) 
				$Sprite2D.scale = Vector2(3, 3)
				life = 1
				damage = 5
	
	$Sprite2D.texture = atlas_texture  # Applique la texture mise à jour

func touch():
	
	var atlas = AtlasTexture.new()
	atlas.atlas = spritetouch
	
	match enemi_type:
		0:#Cell Killer
			if size_level == 3:
				atlas.region = Rect2(0, 0, tile_size.x, tile_size.y) 
			elif size_level == 2:
				atlas.region = Rect2(16, 0, tile_size.x, tile_size.y)
			elif size_level == 1:
				atlas.region = Rect2(32, 0, tile_size.x, tile_size.y)
		1:#Microbe
			if size_level == 2:
				atlas.region = Rect2(0, 16, tile_size.x, tile_size.y) 
			elif size_level == 1:
				atlas.region = Rect2(16, 16, tile_size.x, tile_size.y) 
	if blink < life + 1:
		blink_stat = 1
		$Sprite2D.texture = atlas
		create_timer()
	
func create_timer():
	var timer = Timer.new()  # Crée un Timer
	timer.wait_time = 0.1  # Définit le temps d'attente
	timer.one_shot = true  # Pour qu'il ne se répète pas automatiquement
	timer.timeout.connect(self.callback)  # Connecte la fonction à appeler après le temps écoulé
	add_child(timer)  # Ajoute le Timer à la scène
	timer.start()  # Démarre le Timer
	
func callback():
	if blink_stat == 1:
		$Sprite2D.texture = atlas_texture
		blink += 1
		blink_stat = 2
		create_timer()
	else:
		touch()
	
