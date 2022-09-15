extends Area2D

func _on_DeathArea2D_body_entered(body):#upon entering body
	body.deathtype = 1#call for the variable in body and change it to 4
	body.death()#call for the function death in body
	var time_in_seconds = 2 #variable set to a number that we'll use for timer
	yield(get_tree().create_timer(time_in_seconds), "timeout") #This yield waits for the grabbed tree which is a timer which counts down from our variable
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()#reload current scene
