extends CharacterBody2D


@export var speed: float = 200.0  # Vitesse du joueur
@export var life: int = 100 # vie du personnage
@export var bullet_scene: PackedScene  # Référence à la scène de la balle (bullet.tscn)
@onready var sprite: Sprite2D = $Sprite2D  # Récupère le sprite du joueur

@export var texture_mov : Texture2D
@export var texture_fire : Texture2D
@export var texture_mov_red : Texture2D
@export var texture_fire_red : Texture2D
@export var texture_arrow: Texture2D
var hud
var cytokine
var radius
var direction
var arrow_position
@export var speed_fire : float = 0.1
var free_fire = true
var current_texture :Texture2D

func _ready():
	add_to_group("player")
	$Sprite2D.texture = texture_mov
	current_texture = texture_mov
	hud = get_tree().get_first_node_in_group("hud")
	if not hud:
		print("NOT")
	$Arrows.texture = texture_arrow
	radius = 50
	direction = (get_global_mouse_position() - global_position).normalized()
	arrow_position = global_position + (direction * radius)
	$Arrows.global_position = arrow_position
	$Arrows.look_at(get_global_mouse_position())

	$CollisionShape2D.scale = Vector2(3, 3)
	cytokine = 0
	
func _process(delta):
	move_player(delta)
	
	direction = (get_global_mouse_position() - global_position).normalized()
	arrow_position = global_position + (direction * radius)
	$Arrows.global_position = arrow_position
	$Arrows.look_at(get_global_mouse_position())#probleme lorsque le curseur et entre la fleche et le joueur

	if Input.is_action_pressed("tirer"):
		$Sprite2D.texture = texture_fire
		current_texture = texture_fire
		#create_timer()
		if free_fire:
			free_fire = false
			shoot()
			create_timer3()
	if Input.is_action_just_released("tirer"):
		$Sprite2D.texture = texture_mov
		current_texture = texture_mov
		
			
func move_player(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("droite"):
		direction.x += 1
	if Input.is_action_pressed("gauche"):
		direction.x -= 1
	if Input.is_action_pressed("haut"):
		direction.y -= 1
	if Input.is_action_pressed("bas"):
		direction.y += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()

func shoot():
	var sound_player = AudioStreamPlayer.new()  # Crée un nouveau lecteur audio
	sound_player.stream = $fire_sound.stream  # Associe le son
	add_child(sound_player)  # Ajoute le lecteur audio à la scène
	sound_player.bus = "fire"
	sound_player.play()  # Joue le son
	
	# Supprime le son après lecture
	sound_player.finished.connect(func(): sound_player.queue_free())

	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)  # Ajoute la balle à la scène
		bullet.direction = (get_global_mouse_position() - global_position).normalized() 
		var offset_distance = 10  # Distance de sortie de la balle
		bullet.global_position = global_position + (bullet.direction * offset_distance) 

func take_damage(amonut):
	life -= amonut
	
	hud.decrease_health(life)
	print ("life = ", life)
	if life <= 0:
		queue_free()
	else:
		blink()
	
func blink():
	print($Sprite2D.texture)
	if current_texture == texture_mov:
		$Sprite2D.texture = texture_mov_red
		current_texture = texture_mov_red
	else:
		$Sprite2D.texture = texture_fire_red
		current_texture = texture_fire_red
	create_timer2()
	
func create_timer2():
	var timer = Timer.new()  # Crée un Timer
	timer.wait_time = 0.2
	timer.one_shot = true  # Pour qu'il ne se répète pas automatiquement
	timer.timeout.connect(self.callback1)  # Connecte la fonction à appeler après le temps écoulé
	add_child(timer)  # Ajoute le Timer à la scène
	timer.start()  # Démarre le Timer
	
func callback1():
	$Sprite2D.texture = texture_mov
	current_texture = texture_mov

func add_cytokine(add : int):
	cytokine += add
	hud.increase_score(cytokine)
	print("Cytokine ", cytokine)

func create_timer3():
	var timer = Timer.new()  # Crée un Timer
	timer.wait_time = speed_fire
	timer.one_shot = true  # Pour qu'il ne se répète pas automatiquement
	timer.timeout.connect(self.callback3)  # Connecte la fonction à appeler après le temps écoulé
	add_child(timer)  # Ajoute le Timer à la scène
	timer.start()  # Démarre le Timer
	
func callback3():
	free_fire = true
