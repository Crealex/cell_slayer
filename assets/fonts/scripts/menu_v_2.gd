extends Control

var main_scene:Node

func _on_start_pressed() -> void:
	main_scene.start_game()
	self.hide()
 
func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_help.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
