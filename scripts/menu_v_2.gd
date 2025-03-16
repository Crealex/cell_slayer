extends Control

@export var help_menu: PackedScene
var main_scene:Node

func _on_start_pressed() -> void:
	main_scene.start_game()
	main_scene.play_button()
	self.hide()
 
func _on_help_pressed() -> void:
	main_scene.play_button()
	get_tree().change_scene_to_file("res://scenes/menu_help.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
