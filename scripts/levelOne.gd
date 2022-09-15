extends Node2D

onready var bgM = $bgMusicLevelOne#On ready variable that refers to audio node

func _ready():#On ready when first entering scene
	bgM.play()#Play audio from this node
