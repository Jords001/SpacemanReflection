extends Control

func _ready():#On ready when first entering scene
	$VBoxContainer/Start.grab_focus()#Grab the focus of the button Start(for keyboard navigation)

func _on_Start_button_up():#on releasing this button
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Load1.tscn")#load this scene

func _on_LevelSelect_button_up():#on releasing this button
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levelSelect.tscn")#load this scene

func _on_Credits_button_up():#on releasing this button
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://credits.tscn")#load this scene

func _on_Quit_button_up():#on releasing this button
	get_tree().quit()#quit the game
