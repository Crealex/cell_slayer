extends Control



func _on_button_help_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://scenes/menu_v_2.tscn")
