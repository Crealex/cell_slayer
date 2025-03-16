extends Control

@onready var life_bar  = $LifeBar
@onready var tip = $LifeBar/LifeBarTip
@onready var timer_label = $TimerLabel
@onready var score_label = $ScoreLabel
var score: int = 0
var timer :int = 0
var player: Node

func _ready() -> void:
	add_to_group("hud")
	size.x = get_viewport_rect().size.x
	size.y = get_viewport_rect().size.y
	show_score(score)
	$Timer.start()

	$ColorRect.hide()

func _process(delta):
	# Supposons que health_bar.value varie entre health_bar.min_value et health_bar.max_value
	if life_bar.value < life_bar.max_value:
		tip.visible = true
		# Optionnel : ajuste la position du tip en fonction de la largeur actuelle
		var ratio = (life_bar.value - life_bar.min_value) / (life_bar.max_value - life_bar.min_value)
		var fill_width = life_bar.size.x * ratio
		tip.position.x = fill_width
	else:
		tip.visible = false
		
	$ScoreLabel.text = str(score)
	$Label.hide()


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#var new_value = life_bar.value - 10
		#decrease_health(new_value)
	#elif event.is_action("add_score"):
		#score += 1
		#show_score(score)
		
		
func decrease_health(new_health: float):
	print("Value ", life_bar.value)
	var tween = create_tween()
	tween.tween_property(life_bar, "value", new_health, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func update_timer(timer: int) -> void:
	var minutes = timer / 60
	var seconds = timer % 60
	timer_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	

func show_score(score: int) -> void:
	score_label.text = "Score : " + str(score)

func increase_score(val: int):
	score = val
	
func _on_timer_timeout() -> void:
	timer += 1
	update_timer(timer)
