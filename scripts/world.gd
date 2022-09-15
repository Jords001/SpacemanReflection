extends Node2D
var earthMove = false#Sets a variable called earthmove to false

func _process(_delta):#process function runs by default and on delta(time between fps)
	if earthMove == false:#if earthMove is false then pass
		pass
	elif earthMove == true:#if earthMove is true
		self.position -= Vector2(0.0, -2.5)#move self -2.5 units every delta
	if self.position == Vector2(485.0,0.0):#if self position equals x485 and y0
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Load4.tscn")#Load level Load4

func _on_levelThree_moveEarth():#When receiving the signal moveEarth from Node levelThree
	earthMove = true#set earthMove variable to true
