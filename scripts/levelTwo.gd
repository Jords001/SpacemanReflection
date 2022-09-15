extends Node2D

var ufoarea = false#variable for ufoarea(when the player is in ufo) set to false
var ufoactive = 1#variable for the ufo being active
signal ufodeactivated#signal when the ufo gets deactivated
onready var mine1 = $Asteroids/Mine6#onready variable for mine6
onready var mine2 = $Asteroids/Mine7#onready variable for mine7
onready var mine3 = $Asteroids/Mine8#onready variable for mine8
onready var bgm = $bgm#variable for background music

func _ready():#ready function called once on starting/loading level
	bgm.play()#play background music

func _process(_delta):#function for process which is run by delta (time between fps)
	self.rotatemines(_delta)#on delta run this function

func _input(_event):
	if ufoarea == true:#if ufo area equals true
		if Input.is_action_pressed("controlUse"):# if E or controlUse is pressed
			ufoactive = 0#ufoactive is changed to 0
			self.emit_signal ("ufodeactivated")#and signal ufodeactivated is sent


func _on_ufoDeactivateArea2D_body_entered(_body):#on entering body Ufo area becomes true
	ufoarea = true
	#print("ufoareaenter")#FORDEBUGGING
	#print(ufoarea)#FORDEBUGGING

func _on_ufoDeactivateArea2D_body_exited(_body):#on exiting body Ufo area becomes false
	ufoarea = false
	#print("ufoareaexit")#FORDEBUGGING
	#print(ufoarea)#FORDEBUGGING
	
func rotatemines(_delta):#function for rotate mines called every delta(time between fps)
	mine1.rotation_degrees += 1#rotate mine 1 degree per delta
	mine2.rotation_degrees += 1#rotate mine 1 degree per delta
	mine3.rotation_degrees += 1#rotate mine 1 degree per delta
