extends KinematicBody2D

var velocity = Vector2(0,0)
var alive = true
onready var SS = $AnimatedSprite
onready var SSf = $AnimatedSprite2
onready var rE = $rocketEngine
onready var SSe =$explosion
onready var SSc =$SSCollisionShape2D
var deathtime_in_seconds = 2
signal showdeathUI


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	SSf.play("default")#play space shuttle fire animation
	rE.play()#play rocket engine audio
	
	
func _physics_process(_delta):#physics process which runs by default and is run every delta(time between fps)
	if alive == true:#If the variable alive equals true
		if Input.is_action_pressed("controlLeft"): ##if left arrow is pressed
			velocity.x = -1000#Move the sprite with a velocity of -400 on the x axis


		elif Input.is_action_pressed("controlRight"):#This one is the opposite so that when the right arrow is pressed 
			velocity.x = 1000 #velocity x is 400
			
# warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector2.UP)#Determines that the type of velocity is move and slide which can move and slide other nodes 
		velocity.x = lerp(velocity.x,0,0.2)## this line above is linear interpolation which works like friction interpolating between 0 and .1
	else:
		pass
func death():
		alive = false #change alive variable to false
		self.emit_signal("showdeathUI")#Unhides the death UI
		SSc.queue_free()#culls the collision for the spaceship so that other objects can't trigger it in the short time before restarting
		SSf.play("empty")#plays the empty animation on the Space Shuttle fire
		SS.play("SSdeath")#plays the animation padeath
		SSe.play()#plays the spaceship explosion
		rE.stop()#stops the rocketengine audio
		yield(get_tree().create_timer(deathtime_in_seconds), "timeout")#Waits deathtime in this case two seconds
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()#reloads current scene
