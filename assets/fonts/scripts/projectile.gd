extends Area2D

@export var speed: float = 500.0  # Vitesse de la balle
var direction: Vector2 = Vector2.ZERO  # Direction du tir

func _ready():
	add_to_group("bullets")  # Ajoute la balle au groupe des projectiles

func _process(delta):
	global_position += direction * speed * delta  # Déplace la balle

	# Supprime la balle si elle sort de l'écran
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):  # Vérifie si la balle touche un ennemi
		body.split()  # Appelle la fonction de division de l'ennemi
		queue_free()  # Supprime la balle après l'impact
