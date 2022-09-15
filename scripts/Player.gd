extends KinematicBody2D
##This is what to apply the script to
var fuel = 0#varialbe for fuel that gets added to when the player picks up the fuel collectible
var liftoff = 0#Variable for liftoff, called by win area in level one, changed when the player has enough fuel
var velocity = Vector2(0,0)#Variable for velocity default not moving
##vector2 is the 2D equivalent for physics only needs two coordinates X and Y
var gravity = 1000#Variable for gravity value
##variable for gravity
var jumpcount = 1#Jump count so that the player can't jump infinitely once in the air
onready var aS = $AnimatedSprite#On ready variable to call sprite node
var vY = velocity.y
#onready var deathSp = "../$deathSprite"
var deathtime_in_seconds = 2
var moveable = true#a variable that can be set to false to stop the player moving
var deathtype = 1#defines what killed the player as a variable to be called
var truevar = true#True variable
var falsevar = false#False variable
signal showdeathUI#Signal for the deathUI to reveal itself

func _input(_event):
	if Input.is_action_pressed("exitToMenu"):#When escape is pressed exit to menu
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Menu.tscn")
		
func cutsceneFinish():#Function that will be called by the win area
	moveable = false#Sets the player to unmoveable by changing variable
	aS.visible = false#Sets player sprite to invisible

func death():
	if deathtype == 1:#Death type 1, default death type, stop player movement, emit signal to deathUI, play death animation and countdown from 2
		moveable = false
		self.emit_signal("showdeathUI")
		aS.play("padeath")#plays the animation padeath
		yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	elif deathtype == 2:#Death type 2, burning death, stop player movement, emit signal to deathUI,play death animation and countdown from 2
		moveable = false
		self.emit_signal("showdeathUI")
		aS.play("padeathburnt")#plays the animation padeath
		yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	elif deathtype == 3:#Death type 2, enemy blob death, stop player movement, emit signal to deathUI,play death animation and countdown from 2
		moveable = false
		self.emit_signal("showdeathUI")
		aS.play("padeathblob")#plays the animation padeath
		yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

func _physics_process(_delta):
	if moveable == (true):
##function for physics that updates on delta
		#if Input.is_action_pressed("debugflyup"):#FOR DEBUGGING FLY UP MAX SPEED 
			#velocity.y= -1500
		#if Input.is_action_pressed("debugflyleft"):#FOR DEBUGGING FLY LEFT FAST
			#velocity.x= -3000
		#if Input.is_action_pressed("debugflyright"):#FOR DEBUGGING FLY RIGHT FAST
			#velocity.x= 3000
		if Input.is_action_pressed("controlLeft") and not is_on_floor():#Move left when in the air and A is pushed
			velocity.x = -400
		if Input.is_action_pressed("controlRight") and not is_on_floor():#Move right when in the air and D is pushed
			velocity.x = 400
		if Input.is_action_just_pressed("controlSpace"):# and is_on_floor():
			if jumpcount <= 0:#If jump count is 0 then pass
				pass
			else:
				velocity.y= -500#Else let jump again
				jumpcount -= 1#And minus one from jumpcount
				#print (jumpcount)#FORDEBUGGING PRINT JUMPCOUNT
		if Input.is_action_pressed("controlSpace") and is_on_floor() and Input.is_action_pressed("controlShift"):#If Shift and Space are pushed jump even higher
				velocity.y= -700
			

		if is_on_floor():#If the 2D area is on the floor add 1 to jump count
			jumpcount += 1
		
		if Input.is_action_pressed("controlLeft") and is_on_floor(): ##if left arrow is pressed
			velocity.x = -400#Move the sprite with a velocity of -200 on the x axis
			aS.play("parun")#play animated sprite 'run' 
			aS.flip_h = true#flip the sprite horizontally

		elif Input.is_action_pressed("controlRight") and is_on_floor():#This one is the opposite so that when the right arrow is pressed 
			velocity.x = 400 #velocity x is 200 play animation run don't flip
			aS.play("parun")
			aS.flip_h = false
		elif not is_on_floor():#if the areashape is not on the floor
			if velocity.x <= -0:#If velocity is less than or equal to minus 0
				aS.play("pafall")#Play pafall from aS
				aS.flip_h = true  #flip aS
			elif velocity.x >=0:#otherwise if velocity is greater than 0
				aS.play("pafall")#Play pafall from aS
				aS.flip_h = false#flip aS
		else:
			aS.play("paidle") ##otherwise play the idle animation

	jumpcount = clamp(jumpcount, 0,1)#Clamps jump count so the least it can be is 0 and max is 1
	velocity.y = velocity.y + gravity * (_delta)#This adds the gravity variable then makes the y velocity a multiple of of delta
	velocity.y = clamp(velocity.y, -1500, 800)#This clamps velocity.y so the min it can equal is -1500 and max it can equal is 1000
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP)#Determines that the type of velocity is move and slide which can move and slide other nodes 
	velocity.x = lerp(velocity.x,0,0.2)## this line above is linear interpolation which works like friction interpolating between 0 and .1
func fuel_count():
	fuel = fuel + 1#Add one fuel when fuelcount is called
	if fuel >= (3):#if fuel is greater than or equal to three
		liftoff = 1#then liftoff equals one
		#print ("ready for liftoff")#FOR DEBUGGING PRINT READY FOR LIFTOFF
	#print (fuel)#FOR DEBUGGING PRINT FUEL
	#print (liftoff)#FOR DEBUGGING PRINT LIFTOFF
