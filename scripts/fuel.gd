extends Node2D

onready var fS = $fuelSprite#on ready variable that grabs sprite node
onready var fAu = $fuelAudio#on ready variable that grabs audio node
onready var fSh2D = $fuelShape2D#on ready variable for fuelShape2D
var time_in_seconds = 0.28#Time in seconds, has to be enough to cover the sound effect only once

func _ready():#On ready when first entering scene
	fS.play("fuelIdle") #plays it's animation fuelIdle
		

func _on_fuelArea_body_entered(body):#On entering body
	body.fuel_count() ## searches for the body that entered fuelArea and tells it to run it's function fuel_count
	fAu.play()#play fuel Audio
	fSh2D.queue_free()#queue free collision shape for fuel, stops multiple activation
	fS.queue_free()#queue free fuel sprite
	yield(get_tree().create_timer(time_in_seconds), "timeout")#yield until timeout
	queue_free()#cull node and children




