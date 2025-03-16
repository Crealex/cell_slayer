extends Area2D

@export var speed: float = 0.5
@onready var timer_war = $WarningTimer
@onready var timer_depop = $DepopTimer 

var origin_scale

func _ready() -> void:
	add_to_group("cytokine")
	body_entered.connect(_on_body_entered)
	origin_scale = scale
	$AnimatedSprite2D.play("default")
	timer_war.start()
	timer_depop.start()
	pulse()

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.rotate(0.03 * speed)
	
func pulse() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", origin_scale * 1.2, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", origin_scale, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	pulse()
	
func _on_body_entered(body):
	body.add_cytokine(1)
	queue_free()


func _on_warning_timer_timeout() -> void:
	$AnimatedSprite2D.play("warning")

func _on_depop_timer_timeout() -> void:
	queue_free()
