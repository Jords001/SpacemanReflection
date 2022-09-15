extends Area2D

var level2ffd = false#variable for level 2 forcefield
var liftoff = false#variable for level 1 win parameter
var wintime_in_seconds = 3#time to show rocket taking off

func _ready():#On ready when first entering scene
	$Label.hide()#Hides the child Label
	$ePFSprite.visible = false#hide the rocket fire animation

func _process(_delta):
	if liftoff == true:#if liftoff is set to true then move self =5 on the y position per delta 
		self.position += Vector2(0,-5)

func _on_Area2D_body_entered(body):#On entering the body
	if body.get("liftoff"):#if the body that entered has a variable liftoff
		body.cutsceneFinish()#call for function cutscenestart on body
		liftoff = true#set liftoff to true
		$escapePodSprite.play("takeoff")#play take off animation
		$ePFSprite.visible = true#set rocket fire to visible
		$ePFSprite.play("default")#play rocket fires default animation
		$rocketEngine.play()#play sound rocket engine
		yield(get_tree().create_timer(wintime_in_seconds), "timeout")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Load2.tscn")#Then change the scene(set to same scene for now)
	if level2ffd == true:#if the variable for level2 is true
		body.cutsceneFinish()#call for function cutscenestart on body
		liftoff = true#set liftoff to true
		$escapePodSprite.play("takeoff")#play take off animation
		$ePFSprite.visible = true#set rocket fire to visible
		$ePFSprite.play("default")#play rocket fires default animation
		$rocketEngine.play()#play sound rocket engine
		yield(get_tree().create_timer(wintime_in_seconds), "timeout")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Load3.tscn")
	else:
		$Label.show()#(else show the label which has the text not enough fuel
		#print("not enough fuel")###FOR DEBUGGING
# warning-ignore:unused_argument
func _on_WinArea2D2_body_exited(_body):#On exiting the body
	$Label.hide()#Hide child label

func _on_levelTwo_ufodeactivated():#on receiving the signal ufo deactivated set level 2 variable to true
	level2ffd = true
