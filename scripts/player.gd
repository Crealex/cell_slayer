extends CharacterBody2D


@export var speed: float = 200.0  # Vitesse du joueur
@export var life: int = 100 # vie du personnage
@export var bullet_scene: PackedScene  # Référence à la scène de la balle (bullet.tscn)
@onready var sprite: Sprite2D = $Sprite2D  # Récupère le sprite du joueur

@export var texture_mov : Texture2D
@export var texture_fire : Texture2D
@export var texture_arrow: Texture2D
var hud
var cytokine
var radius
var direction
var arrow_position
@export var speed_fire : float = 0.1
var free_fire = true

func _ready():
	add_to_group("player")
	$Sprite2D.texture = texture_mov
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
		create_timer()
		if free_fire:
			free_fire = false
			shoot()
			create_timer3()
		
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
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)  # Ajoute la balle à la scène
		bullet.direction = (get_global_mouse_position() - global_position).normalized() 
		var offset_distance = 10  # Distance de sortie de la balle
		bullet.global_position = global_position + (bullet.direction * offset_distance) 

func create_timer():
	var timer = Timer.new()  # Crée un Timer
	timer.wait_time = 0.5
	timer.one_shot = true  # Pour qu'il ne se répète pas automatiquement
	timer.timeout.connect(self.callback)  # Connecte la fonction à appeler après le temps écoulé
	add_child(timer)  # Ajoute le Timer à la scène
	timer.start()  # Démarre le Timer
	
func callback():
	$Sprite2D.texture = texture_mov

func take_damage(amonut):
	life -= amonut
	hud.decrease_health(life)
	print ("life = ", life)
	if life <= 0:
		queue_free()
	else:
		blink()
	
func blink():
	$Sprite2D.texture = null
	create_timer2()
	
func create_timer2():
	var timer = Timer.new()  # Crée un Timer
	timer.wait_time = 0.1
	timer.one_shot = true  # Pour qu'il ne se répète pas automatiquement
	timer.timeout.connect(self.callback1)  # Connecte la fonction à appeler après le temps écoulé
	add_child(timer)  # Ajoute le Timer à la scène
	timer.start()  # Démarre le Timer
	
func callback1():
	$Sprite2D.texture = texture_mov

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
