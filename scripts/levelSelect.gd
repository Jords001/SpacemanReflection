extends Control

func _ready():
	$VBoxContainer/Menu.grab_focus()#Grab the focus of the button Start(for keyboard navigation)

func _on_Menu_button_up():#on menu button up
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu.tscn")#load this scene
func _on_LevelOne_button_up():#on LevelOne button up
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Load1.tscn")#load this scene
func _on_LevelTwo_button_up():#on LevelTwo button up
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Load2.tscn")#load this scene
func _on_LevelThree_button_up():#on LevelThree button up
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Load3.tscn")#load this scene
func _input(_event):
	if Input.is_action_pressed("exitToMenu"):#if escape is pressed exit ot menu
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Menu.tscn")
