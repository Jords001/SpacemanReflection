extends Area2D

onready var HidSto = $hideableStone#Variable for sprite

func _ready():#On ready
	HidSto.visible = true#Show this sprite


func _on_caveHideArea_body_entered(_body):#When entering the body
	#print("BODY ENTERED")#FOR DEBUGGING
	HidSto.visible = false#Hide this sprite



func _on_caveHideArea_body_exited(_body):#When exiting this body
	HidSto.visible = true#Show this sprite
