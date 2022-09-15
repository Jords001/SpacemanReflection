extends Node2D

func _input(_event):#on input even run this funtion
	if self.name == "Load1":
		if Input.is_action_just_pressed("controlSpace"):#if self name equals Load1 if spacebar is pressed load levelOne
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://levelOne.tscn")
	if self.name == "Load2":
		if Input.is_action_just_pressed("controlSpace"):#if self name equals Load2 if spacebar is pressed load levelOne
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://levelTwo.tscn")
	if self.name == "Load3":
		if Input.is_action_just_pressed("controlSpace"):#if self name equals Load3 if spacebar is pressed load levelOne
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://levelThree.tscn")
	if self.name == "Load4":
		if Input.is_action_just_pressed("controlSpace"):#if self name equals Load4 if spacebar is pressed load levelOne
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://credits.tscn")
	if self.name == "credits":
		if Input.is_action_just_pressed("controlSpace"):#if self name equals credits if spacebar is pressed load levelOne
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Menu.tscn")
	if Input.is_action_pressed("exitToMenu"):#if escape is pressed exit ot menu
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Menu.tscn")
