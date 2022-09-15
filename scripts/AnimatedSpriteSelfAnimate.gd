#This script is used on level one to animate the dust in the back and foreground
extends ParallaxLayer#This script is used to animate ParallaxLayer with default animation

onready var aS = $AnimatedSprite#On ready grab child node sprite

func _ready():#On ready when first entering scene
	aS.play("default")#play sprite animation default
