Monday 5th September

This is the documentation for the game I started developing on the Godot engine consisting of Gd script. I've tried to cover as many problems as I've had, and update this list. However when things go without any problem I've added quite a few features, and some may go amiss here.

The first problem I encountered when I was creating the game was that the guide I was following used a method that kept breaking to calculate gravity.
It would become exponential. The following is the code that was problematic.

velocity.y = velocity.y + gravity * (delta)

I discovered the issue when I was playtesting the game. After a few seconds of sitting still if you fell off a platform you would instantly hit the ground.
After doing some research I found the easiest solution was to clamp this so that it had a max and min.

velocity.y = clamp(velocity.y, -1500, 800)

This solved the first issue I had.

Another issue I had was that the walk animation would play in midair originating from this piece of code.

		if Input.is_action_pressed("controlLeft"): ##if left arrow is pressed
			velocity.x = -400#Move the sprite with a velocity of -200 on the x axis
			aS.play("parun")#play animated sprite 'run' 
			aS.flip_h = true#flip the sprite horizontally
      
      			elif Input.is_action_pressed("controlRight"):#This one is the opposite so that when the right arrow is pressed 
			  	velocity.x = 400 #velocity x is 200 play animation run don't flip
			  	aS.play("parun")
			  	aS.flip_h = false
        
I got around this by adding some code at the end to check if the player is on the floor and if they're not to play a fall animation.

		if Input.is_action_pressed("controlLeft") and is_on_floor(): ##if left arrow is pressed
			velocity.x = -400#Move the sprite with a velocity of -200 on the x axis
			aS.play("parun")#play animated sprite 'run' 
			aS.flip_h = true#flip the sprite horizontally

	
		elif Input.is_action_pressed("controlRight") and is_on_floor():#This one is the opposite so that when the right arrow is pressed 
			velocity.x = 400 #velocity x is 200 play animation run don't flip
			aS.play("parun")
			aS.flip_h = false
		elif not is_on_floor():#if the areashape is not on the floor
			if velocity.x <= -1:#If velocity is less than or equal to minus 1
				aS.play("pafall")#Play pafall from aS
				aS.flip_h = true  #flip aS
			else:
				aS.play("pafall")
				aS.flip_h = false
				
The next issue I encountered was that the parallax layer wasn't long enough which caued it to load onscreen creating visible popping. The easiest way to fix this was to make the sprite twice as long and flip repeat it myself in an image editor and then the same in the game engine so that when it pop loads/flips it's offscreen making it invisible to the player. The downside to this is that it uses twice as much Vram per time it's called.

I tried a few methods to get a camera to zoom when pressing a button such as the following.

	var zoomzoom = Vector2(0,0)
	func _cameracontrol(delta):
		if Input.is_action_pressed("zoom"):
			zoomzoom.x += .1
			zoomzoom.y += .1
		if Input.is_action_pressed("zoom"):
			zoomzoom.x -= .1
			zoomzoom.y -= .1
		Camera2D.zoom = zoomzoom

and alternatively

	var zoomzoom = Vector2(0,0)
	
	func _cameracontrol(delta):
		if Input.is_action_pressed("zoom"):
			zoom.x = .5
			zoom.y = .5
		if Input.is_action_pressed("zoomout"):
			zoom.x = 1.0
			zoom.y = 1.0
			
In theory these should work, but my error was what I was trying to change exactly. Which should have just been zoom (as the script we were in is an extension of Camera2D else it has to be a referenced node) and it's value set in a variable. I changed it to one button for convenience and I also added a delay because otherwise if you accidently held the key too long it would zoom in and out.

	func _input(event):
		if Input.is_action_pressed("zoom"):#If the action defined as zoom is pushed
			if zoom == zoom_max:#If zoom is set to the same as the var
				yield(get_tree().create_timer(time_in_seconds), "timeout")#grab tree and use variable as time til timeout
				zoom = zoom_min#Set zoom to this var
			else:
				yield(get_tree().create_timer(time_in_seconds), "timeout")#grab tree and use variable as time til timeout
				zoom = zoom_max#Set zoom to this var

 These were the main problems I came across on the first day of making this game.
 
 I also added tutorial signs, which work using a 2DAreaShape and a CollisionShape2D as well as a label and sprite.
 Initially I couldn't get these to quite work the way I wanted, this was before understanding that default nodes and extensions (the first part of the code) have the same spelling. You can get around this by using the dollar sign (which references the node directly) renaming the node or having an onready variable with the full name of the node and a different one in the variable name. The following code is the end result:
 
 	func _ready():#On ready when first entering scene
		$Label.hide()#hide the child label
	# warning-ignore:unused_argument
	func _on_Area2Dztzi_body_entered(_body):#On entering the body
		$Label.show()#Show the child label
	# warning-ignore:unused_argument
	func _on_Area2Dztzi_body_exited(_body):#On exiting the body
		$Label.hide()#Hide child label
 
 Tuesday 6th September
 
 I wanted to make some collectibles for a mission purpose. As well as adding win or lose scenarios/parameters and obstacles. My first problem was trying to add it to an item that clears itself and is a unique instance. I also initially had a seperate script for the animation like so.
 
 	func_ready():
		play("fuelidle")
		
and seperately
 
 	func _on_fuelArea_body_entered(body):#On entering body
		fuel = fuel + 1#Add one fuel when fuelcount is called
		queue_free()#cull script and children
		
This doesn't work because the node gets culled/destroyed. So I added the fuel variable to the player and a func that can be called.

	func fuel_count():
		fuel = fuel + 1#Add one fuel when fuelcount is called
		
Changed the fuel script so that it handles both animation and calls for fuel count.

	onready var fS = $fuelSprite#on ready variable that grabs sprite node

	func _ready():#On ready when first entering scene
		fS.play("fuelIdle") #plays it's animation fuelIdle
		

	func _on_fuelArea_body_entered(body):#On entering body
		body.fuel_count() ## searches for the body that entered fuelArea and tells it to run it's function fuel_count
		queue_free()#cull script and children
	
This worked perfectly.

Next I added an enemy

	var velocity = Vector2(0,0)# This sets a variable for our velocity set to an empty vector
	var speed = 200# A variable that'll act as our main speed for the enemy
	var direction = -1# starting direction for the enemy
	onready var eBS = $EnemyBlobSprite
	func _physics_process(_delta):#Run this process on delta
		velocity.x = speed * direction# This uses direction as a multiplier for speed to determine velocity
		#print ("position" + str(position)) FOR DEBUGGING PRINT POSITION
		if direction == -1:# if the sprite is moving left
			eBS.flip_h = false#Do not flip the sprite
			
		else:
			eBS.flip_h = true#Else flip the sprite
		if velocity == stopped:
			pass
		else:
			eBS.play("blobMove")#Play child $Animated sprite with animation blobMove
	# warning-ignore:return_value_discarded
		move_and_slide(velocity)#Determines that the type of velocity is move and slide which can move and slide other nodes
		if $GroundRayCast2D.is_colliding() == false:#If the raycast doesn't collide
			direction = direction * -1#Change direction(inverse)
			$GroundRayCast2D.position.x *= -1#Changes the position to the relative flipped position
		if $WallRayCast2D.is_colliding() == true:#If the raycast does collide
			direction = direction * -1#Change direction(inverse)
			$WallRayCast2D.position.x *= -1#Changes the position to the relative flipped position
			
	func _on_enemyKillArea2D_body_entered(body):#On area entered
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		
I eventually changed this because as it was the scene would instantly reload which isn't really much fun and the player might not realise they've died. I also removed the wall ray cast as it wasn't working the way I had set it up. The following script also includes some changes that I made on Thursday when I realised you could queue free individual nodes, allowing things like removing an enemy hitbox on it's death so that it doesn't animate twice or alternatively kill you twice. I initially had some trouble with this as I was trying to send a signal to a different tree which alternatively needs another one or two scripts. This way is much tidier, I don't have the original script that was problematic but I'll try replicate it.

	func _on_enemyDieArea2D_body_entered(_body)
		emit_signal ("emitEnemyDead" play)
		
in the enemy Body

	func_ready():
		$EnemyBody2D.connect("emitEnemyDead". $enemyAudioDeath "receiveEnemyDead"
		
In the enemy enemy Death Audio

	func receiveEnemyDead
		play()
		
And similar for the fuel, evidenced by this snippet of leftover code

	onready var fAr = $fuelArea
	onready var fAu = $fuelAudio


	func _ready():
		fAr.connect("playFuelAudio", fAu, "receiveAudio")
		
I also had a death sprite seperate before undestand queue_free which I was trying to copy the translate of another node

	"""extends AnimatedSprite

	onready var eB2D = "../$EnemyBody2D"
	var sTran = transform.origin

	func _ready():
		hide()


	func clonePosition(_delta):
		sTran = eB2D.transform.origin
		pass

	func _on_enemyDieArea2D_body_entered(_body):
		show()
		play ("enemySplat")
		var time_in_seconds = 0.168
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		queue_free()"""
It was a little bit messy. Here's the amended code.

	var stopped = Vector2(0,0)
	var velocity = Vector2(0,0)# This sets a variable for our velocity set to an empty vector
	var speed = 200# A variable that'll act as our main speed for the enemy
	var direction = -1# starting direction for the enemy
	onready var eBS = $EnemyBlobSprite
	func _physics_process(_delta):#Run this process on delta
		velocity.x = speed * direction# This uses direction as a multiplier for speed to determine velocity
		#print ("position" + str(position)) FOR DEBUGGING PRINT POSITION
		if direction == -1:# if the sprite is moving left
			eBS.flip_h = false#Do not flip the sprite
			
		else:
			eBS.flip_h = true#Else flip the sprite
		if velocity == stopped:
			pass
		else:
			eBS.play("blobMove")#Play child $Animated sprite with animation blobMove
	# warning-ignore:return_value_discarded
		move_and_slide(velocity)#Determines that the type of velocity is move and slide which can move and slide other nodes
		if $GroundRayCast2D.is_colliding() == false:#If the raycast doesn't collide
			direction = direction * -1#Change direction(inverse)
			$GroundRayCast2D.position.x *= -1#Changes the position to the relative flipped position
		

	# warning-ignore:unused_argument
	func _on_enemyKillArea2D_body_entered(body):#On area entered
	# warning-ignore:return_value_discarded
		body.death()#Reload the scene


	# warning-ignore:unused_argument
	func _on_enemyDieArea2D_body_entered(_body):#On area entered
		speed = 0
		$enemyKillArea2D.queue_free()
		$enemyDieArea2D.queue_free()#cull script and children
		eBS.stop()# this calls the animation to stop
		eBS.play("blobSplat")#this then calls the death animation
		var time_in_seconds = 0.268
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		queue_free()
		
The following in the audio

	func _on_enemyDieArea2D_body_entered(_body):#On entering body
		play()#play the attached audio file
		var time_in_seconds = 0.675 #variable set to a number that we'll use for timer
		yield(get_tree().create_timer(time_in_seconds), "timeout") #This yield waits for the grabbed tree which is a timer which counts down from our variable
		queue_free() #This acts like a kill script function and kills everything parented to it and itself
		
Upon writing this previous section I have figured a way that I can tidy the script up someore, I found this better because it means all the scripts are in one instead.

	extends KinematicBody2D
	var stopped = Vector2(0,0)
	var velocity = Vector2(0,0)# This sets a variable for our velocity set to an empty vector
	var speed = 200# A variable that'll act as our main speed for the enemy
	var direction = -1# starting direction for the enemy
	onready var eBS = $EnemyBlobSprite
	onready var eBAu= $enemyAudio
	onready var deAu = $enemyAudioDeath
	var eBSsttime = 0.268
	var eBAusttime = 0.407
	var dead = false
	func _ready():
	eBAu.play()
	func _physics_process(_delta):#Run this process on delta
	if dead == false:
		velocity.x = speed * direction# This uses direction as a multiplier for speed to determine velocity
		#print ("position" + str(position)) FOR DEBUGGING PRINT POSITION
		if direction == -1:# if the sprite is moving left
			eBS.flip_h = false#Do not flip the sprite
			
		else:
			eBS.flip_h = true#Else flip the sprite
		if velocity == stopped:
			pass
		else:
			eBS.play("blobMove")#Play child $Animated sprite with animation blobMove
	# warning-ignore:return_value_discarded
		move_and_slide(velocity)#Determines that the type of velocity is move and slide which can move and slide other nodes
		if $GroundRayCast2D.is_colliding() == false:#If the raycast doesn't collide
			direction = direction * -1#Change direction(inverse)
			$GroundRayCast2D.position.x *= -1#Changes the position to the relative flipped position
	else:
		pass

	# warning-ignore:unused_argument
	func _on_enemyKillArea2D_body_entered(body):#On area entered
	# warning-ignore:return_value_discarded
	body.death()#call for death func in body


	# warning-ignore:unused_argument
	func _on_enemyDieArea2D_body_entered(_body):#On area entered
		dead = true #set dead to true so that physics process is passed
		speed = 0 #set speed to 0 so that velocity in turn is 0
		$enemyKillArea2D.queue_free()
		$enemyDieArea2D.queue_free()#cull script and children
		eBS.stop()# this calls the animation to stop
		eBS.play("blobSplat")#this then calls the death animation
		deAu.play()#play death audio
		yield(get_tree().create_timer(eBSsttime), "timeout")#wait eBSsttime .268 seconds
		eBAu.queue_free()#queue free idle audio
		eBS.queue_free()#queue free sprite
		yield(get_tree().create_timer(eBAusttime), "timeout")# wait another .407 seconds
		queue_free()#free entire queue of enemyBody2D
		
Adding a win zone was rather trivial after all of this. I used the following code, adding a if fuel is larger than x under the fuel count of player

	func _ready():#On ready when first entering scene
		$Label.hide()#Hides the child Label
	func _on_Area2D_body_entered(body):#On entering the body
		if body.get("liftoff"):#if the body that entered has a variable liftoff
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://levelOne.tscn")#Then change the scene(set to same scene for now)
		else:
			$Label.show()#(else show the label which has the text not enough fuel
			#print("not enough fuel")###FOR DEBUGGING

	# warning-ignore:unused_argument
	func _on_WinArea2D2_body_exited(_body):#On exiting the body
		$Label.hide()#Hide child label


I mostly added Audio on Wednesday night, which went relatively error free. I did change a few things after learning about queue_free on individual nodes.

Thursday 8th September
Today in class I was getting colleagues to look at my game and see what they thought and what might need adding, most of the thoughts were as follows

A story if time provides
A death animation for the player and for the enemy
A reflection of stars that scrolls/moves in the helmet (not sure how I would do this without some kind of in game mask
Rocketship leaving animation

I started by working on the death animations, the blob splatting and a skull showing up on player and a UI element.

at first I had trouble with the UI element using a sprite because it had no show or hide properties like the Labels, so my original code looked something along the lines of

	deathSp.show()#shows death sprite
which changed to	
	deathSp.visible = true
	
I also was trying to disable input initially by using a tree line of code

	get_tree().get_root().set_disable_input(true)

This wasn't working and instead added a variable called alive and gave it a boolean true/false and added to the top of my physics process a variable check

	if alive == (true):
	
I ended up with a death function which looks like this

	func death():
		alive = false
		deathSp.visible = true #sets the sprite to visible
		aS.play("padeath")#plays the animation padeath
		yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		
Presto, the player gets a death notice and is unable to move the onscreen player.

The next thing I struggled with I covered a little bit already, that was the Enemy death animation, the enemy script was in it's entirety being culled before it could play the animation or the sound. The work around for this was culling nodes one at a time and using timers so that neither the animation or sound would get cut off.

	func _on_enemyDieArea2D_body_entered(_body):#On area entered
		dead = true #set dead to true so that physics process is passed
		speed = 0 #set speed to 0 so that velocity in turn is 0
		$enemyKillArea2D.queue_free()
		$enemyDieArea2D.queue_free()#cull script and children
		eBS.stop()# this calls the animation to stop
		eBS.play("blobSplat")#this then calls the death animation
		deAu.play()#play death audio
		yield(get_tree().create_timer(eBSsttime), "timeout")#wait eBSsttime .268 seconds
		eBAu.queue_free()#queue free idle audio
		eBS.queue_free()#queue free sprite
		yield(get_tree().create_timer(eBAusttime), "timeout")# wait another .407 seconds
		queue_free()#free entire queue of enemyBody2D
Friday I added 2 unique death animations on the player and a death type, so depending on which deathtype is told by the 2DAreaShape the sprite will adjust accordingly, looking something like this

	func death():
	if deathtype == 1:
		alive = false
		deathSp.visible = true #sets the sprite to visible
		aS.play("padeath")#plays the animation padeath
		yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	elif deathtype == 2:
		alive = false
		deathSp.visible = true #sets the sprite to visible
		aS.play("padeathburnt")#plays the animation padeath
		yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	elif deathtype == 3:
		alive = false
		deathSp.visible = true #sets the sprite to visible
		aS.play("padeathblob")#plays the animation padeath
		yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		
I also added a mine that explodes with sound.

	onready var mS = $mineSprite
	onready var mAu = $mineAudio
	var mineexplodedtime = 1.24

	func _ready():
		mS.play("mineidle")

	func _on_mineArea2D_body_entered(body):#on body entering area
		body.deathtype = 2
		body.death()
		$CollisionShape2D.queue_free()
		mS.stop()
		mS.play("mineexplode")
		mAu.play()
		yield(get_tree().create_timer(mineexplodedtime),"timeout")
		queue_free()
I also changed things around with the camera and UI so that the camera is no longer parented and just copies the player position, I tried a few times to get this to work previously but now it works flawlessly.

	extends Camera2D
	var zoom_min = Vector2(1.0,1.0)#var zoom vector set to 1 (zoomed out)
	var zoom_max = Vector2(.55,.55)#var zoom vector set to .55 (zoomed in)
	var time_in_seconds = 0.150#var set to use for timer
	onready var deathSp = $deathSprite
	var follow = true

	func _ready():
		deathSp.visible = false

	func _process(delta):
		if follow == true:
			self.position = get_parent().get_node("KinematicBody2D").position
		else:
			 pass

	# warning-ignore:unused_argument
	func _input(event):
		if Input.is_action_pressed("zoom"):#If the action defined as zoom is pushed
			if zoom == zoom_max:#If zoom is set to the same as the var
				yield(get_tree().create_timer(time_in_seconds), "timeout")#grab tree and use variable as time til timeout
				zoom = zoom_min#Set zoom to this var
				offset.y = -200
			else:
				yield(get_tree().create_timer(time_in_seconds), "timeout")#grab tree and use variable as time til timeout
				zoom = zoom_max#Set zoom to this var
				offset.y = 0


	func _on_KinematicBody2D_showdeathUI():
		deathSp.visible = true
		follow = false
and in player

	signal showdeathUI
	func _ready():
		pass

	func death():
		if deathtype == 1:
			alive = false
			self.emit_signal("showdeathUI")
			aS.play("padeath")#plays the animation padeath
			yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
		# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
		elif deathtype == 2:
			alive = false
			self.emit_signal("showdeathUI")
			aS.play("padeathburnt")#plays the animation padeath
			yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
		# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
		elif deathtype == 3:
			alive = false
			self.emit_signal("showdeathUI")
			aS.play("padeathblob")#plays the animation padeath
			yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
		# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
		elif deathtype == 4:
			alive = false
			self.emit_signal("showdeathUI")
			aS.play("padeath")#plays the animation padeath
			#$playerCamera2D.current = false
			yield(get_tree().create_timer(deathtime_in_seconds), "timeout")
		# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
This also allows me to decouple the UI from the player and attach it to the camera. This was all made possible by signals.

I decided to change the camera system so that it can be done in increments using plus and minus instead.

	var zoom_min = Vector2(1.0,1.0)#var zoom vector set to 1 (zoomed out)
	var zoom_max = Vector2(0.60,0.60)#var zoom vector set to .55 (zoomed in)
	var time_in_seconds = 0.150#var set to use for timer
	onready var deathSp = $deathSprite
	var zoom_increment = Vector2(.05,.05)
	var follow = true
	var zoomamount = zoom
	var zoomextension = Vector2(1.0,1.0)

	func _ready():
		deathSp.visible = false

	func _process(_delta):
		if follow == true:
			self.position = get_parent().get_node("KinematicBody2D").position
		else:
			 pass

	# warning-ignore:unused_argument
	func _input(event):
		zoomextension.x = clamp(zoomextension.x, 0.6,1.0)
		zoomextension.y = clamp(zoomextension.y, 0.6,1.0)
		#zoom_increment = clamp(zoom_increment.y, 0.0,1.0)
		if Input.is_action_pressed("zoomout"):#If the action defined as zoomin is pushed
			if zoomextension == zoom_min:#If zoom is set to the same as the var
				pass
			else:
				zoom += zoom_increment
				zoomextension += zoom_increment
		if Input.is_action_pressed("zoomin"):#If the action defined as zoomin is pushed
			if zoomextension == zoom_max:
				pass
			else:
				zoom -= zoom_increment
				zoomextension -= zoom_increment
				print (zoomextension)

	func _on_KinematicBody2D_showdeathUI():
		deathSp.visible = true
		follow = false

I added a UFO and some level coding as well as some asteroids for level 2. UFO:

	var ufoactive = 1
	# Declare member variables here. Examples:
	# var a = 2
	# var b = "text"


	# Called when the node enters the scene tree for the first time.
	func _ready():
		pass # Replace with function body.


	# Called every frame. 'delta' is the elapsed time since the previous frame.
	#func _process(delta):
	#	pass


	func _on_ufoArea2D_body_entered(body):
		if ufoactive == 1:
			body.velocity.y = -1000
		else:
			pass


	func _on_ufoStopArea2D_body_entered(body):
		body.velocity.y = 0


	func _on_ufoDeactivateArea2D_body_entered(_input):
		$UFOcutaway.visible = false


	func _on_ufoDeactivateArea2D_body_exited(_body):
		$UFOcutaway.visible = true
		
Levelcode:

	
	var ufoarea = false
	var ufoactive = 1

	# Called when the node enters the scene tree for the first time.
	func _ready():
		pass # Replace with function body.

	# Called every frame. 'delta' is the elapsed time since the previous frame.
	#func _process(delta):
	#	pass

	func _input(_event):
		if ufoarea == true:
			if Input.is_action_pressed("controlUse"):
				ufoactive = 0
				print("ufodeactivated")


	func _on_ufoDeactivateArea2D_body_entered(_body):
		ufoarea = true
		#print("ufoareaenter")
		#print(ufoarea)



	func _on_ufoDeactivateArea2D_body_exited(_body):
		ufoarea = false
		#print("ufoareaexit")
		#print(ufoarea)
Asteroids:

	extends ParallaxLayer

	var asteroid_speed = -10

	onready var abg1 = $asteroid1Sbg/asteroid1bg
	onready var abg2 = $asteroid1Sbg2/asteroid1bg
	onready var abg3 = $asteroid1Sbg3/asteroid1bg
	onready var abg4 = $asteroid1Sbg4/asteroid1bg
	onready var abg5 = $asteroid1Sbg5/asteroid1bg
	onready var abg6 = $asteroid1Sbg6/asteroid1bg
	onready var abg7 = $asteroid2bg/asteroid2bg
	onready var abg8 = $asteroid2bg2/asteroid2bg
	onready var abg9 = $asteroid2bg3/asteroid2bg
	onready var abg10 = $asteroid3Still/asteroid3bg
	onready var abg11 = $asteroid3Still2/asteroid3bg
	onready var abg12 = $asteroid3Still3/asteroid3bg
	onready var abg13 = $asteroid3Still4/asteroid3bg
	onready var abg14 = $asteroid4bg/asteroid4bg
	onready var abg15 = $asteroid4bg2/asteroid4bg
	onready var abg16 = $asteroid4bg3/asteroid4bg
	onready var abg17 = $asteroid4bg4/asteroid4bg
	onready var abg18 = $asteroid4bg5/asteroid4bg
	onready var abg19 = $asteroid4bg6/asteroid4bg

	func _process(delta) -> void:
		self.motion_offset.x += asteroid_speed * delta
		abg1.rotation_degrees += 2
		abg2.rotation_degrees -= 1
		abg3.rotation_degrees += .5
		abg4.rotation_degrees -= 2
		abg5.rotation_degrees -= 1
		abg6.rotation_degrees += .5
		abg7.rotation_degrees += 2
		abg8.rotation_degrees += 1
		abg9.rotation_degrees -= 2
		abg10.rotation_degrees += 2
		abg11.rotation_degrees -= 1
		abg12.rotation_degrees -= 2
		abg13.rotation_degrees += .5
		abg14.rotation_degrees += 1
		abg15.rotation_degrees -= 2
		abg16.rotation_degrees += 2
		abg17.rotation_degrees -= 1
		abg18.rotation_degrees += .5
		abg19.rotation_degrees -= 2


	# Called when the node enters the scene tree for the first time.
	func _ready():
		pass # Replace with function body.


	# Called every frame. 'delta' is the elapsed time since the previous frame.
	#func _process(delta):
	#	pass

I've added quite a bit since I last journalled including a third level different player mechanics for said level, I commented on all my code, added a lift off sequence to the end of the levels, added menus and story loading screens. I think that most things went straight forward, the only trial and error moments I had was with getting a signal to work, but I had it on a function that wasn't being called which was the main problem there. The other problem was one of my fonts wasn't displaying correctly, but it turned out to be a problem with the file itself, I changed the spacing on it to global and the problem went away. I will post all the scripts below, they have commented on them where they are used.

This script is used on level one to animate the dust in the back and foreground

	extends ParallaxLayer#This script is used to animate ParallaxLayer with default animation

	onready var aS = $AnimatedSprite#On ready grab child node sprite

	func _ready():#On ready when first entering scene
		aS.play("default")#play sprite animation default
		
This script is used to control the camera in levels one and two

	extends Camera2D
	var zoom_min = Vector2(1.0,1.0)#var zoom vector set to 1 (zoomed out)
	var zoom_max = Vector2(0.60,0.60)#var zoom vector set to .55 (zoomed in)
	var zoomextension = Vector2(1.0,1.0)#zoom extension which can be clamped
	var zoom_increment = Vector2(.05,.05)#variable for the increment of zoom
	onready var deathSp = $deathSprite#onready variable for deathsprite
	var follow = true#follow variable by default equals true


	func _ready():#on ready function, called once at the start of level
		deathSp.visible = false#set death UI to invisible

	func _process(_delta):
		if follow == true:#If follow is set to true
			self.position = get_parent().get_node("KinematicBody2D").position#Copy the position of KinematicBody2D(the player(, get_parent has to be used here because they are siblings, and only children can be called directly
		else:
			 pass#else if false don't follow the player or pass

	# warning-ignore:unused_argument
	func _input(event):
		zoomextension.x = clamp(zoomextension.x, 0.6,1.0)#clamp zoom extension maximum and minimum x axis
		zoomextension.y = clamp(zoomextension.y, 0.6,1.0)#clamp zoom extension maximum and minimum y axis
		if Input.is_action_pressed("zoomout"):#If the action defined as zoomin is pushed
			if zoomextension == zoom_min:#If zoom extension is set to the same as the var (min) then pass
				pass
			else:
				zoom += zoom_increment#otherwise increase zoom by zoom increment
				zoomextension += zoom_increment#and do the same to zoom extension
		if Input.is_action_pressed("zoomin"):#If the action defined as zoomin is pushed
			if zoomextension == zoom_max:#if zoom extension is set to the same as the var (max) then pass
				pass
			else:
				zoom -= zoom_increment#otherwise decrease zoom by zoom increment
				zoomextension -= zoom_increment#and do the same to zoom extension

	func _on_KinematicBody2D_showdeathUI():
		deathSp.visible = true#change deathUI sprite to visible
		follow = false#change follow to false
		
This script is used for the fall box on level two

	extends Area2D

	func _on_DeathArea2D_body_entered(body):#upon entering body
		body.deathtype = 1#call for the variable in body and change it to 4
		body.death()#call for the function death in body
		var time_in_seconds = 2 #variable set to a number that we'll use for timer
		yield(get_tree().create_timer(time_in_seconds), "timeout") #This yield waits for the grabbed tree which is a timer which counts down from our variable
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()#reload current scene

This script controls the enemy blob

	extends KinematicBody2D
	var stopped = Vector2(0,0)#variable definition for stopped
	var velocity = Vector2(0,0)# This sets a variable for our velocity set to an empty vector
	var speed = 200# A variable that'll act as our main speed for the enemy
	var direction = -1# starting direction for the enemy
	onready var eBS = $EnemyBlobSprite#onready variable for enemy blob sprite
	onready var eBAu= $enemyAudio#onready variable for enemy blob audio
	onready var deAu = $enemyAudioDeath#onready variable for enemy blob audio death
	var dead = false#variable for dead set to false by default
	func _ready():#onready called once at the start of the level
		eBAu.play()#onready play enemy blob audio
	func _physics_process(_delta):#Run this process on delta
		if dead == false:#if dead equals false continue
			velocity.x = speed * direction# This uses direction as a multiplier for speed to determine velocity
			#print ("position" + str(position)) FOR DEBUGGING PRINT POSITION
			if direction == -1:# if the sprite is moving left
				eBS.flip_h = false#Do not flip the sprite

			else:
				eBS.flip_h = true#Else flip the sprite
			if velocity == stopped:#if velocity is equal to variable stop (0)
				pass#then pass, don't play animation
			else:
				eBS.play("blobMove")#Play child $Animated sprite with animation blobMove
	# warning-ignore:return_value_discarded
			move_and_slide(velocity)#Determines that the type of velocity is move and slide which can move and slide other nodes
			if $GroundRayCast2D.is_colliding() == false:#If the raycast doesn't collide
				direction = direction * -1#Change direction(inverse)
				$GroundRayCast2D.position.x *= -1#Changes the position to the relative flipped position
		else:
			pass

	# warning-ignore:unused_argument
	func _on_enemyKillArea2D_body_entered(body):#On area entered
		body.deathtype = 3#calls for death type to be changed to 3 in body
		body.death()#call for death func in body


	# warning-ignore:unused_argument
	func _on_enemyDieArea2D_body_entered(_body):#On area entered
		dead = true #set dead to true so that physics process is passed
		speed = 0 #set speed to 0 so that velocity in turn is 0
		$enemyKillArea2D.queue_free()#cull node and children this is to stop accidental second triggering
		$enemyDieArea2D.queue_free()#cull node and children this is to stop accidental second triggering
		eBS.play("blobSplat")#this then calls the death animation
		eBAu.stop()#stop enemy blob idle audio
		deAu.play()#play death audio

This script controls the fire

	extends Area2D

	onready var fS = $fireSprite#On ready variable that refers to Sprite node
	onready var fAu = $fireAudio#On ready variable that refers to Audio node

	func _ready():#On ready when first entering scene
		fS.play("fire")#play sprite animation fire
		fAu.play ()#play audio from this node

	func _on_fireArea2D_body_entered(body):#on body entering area
		body.deathtype = 2#call for deathtype variable change to 2 in body
		body.death()#call for death function in body
		
This script controls fuel collectible on level one

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
		
This script controls the hidden area on level one

	extends Area2D

	onready var HidSto = $hideableStone#Variable for sprite

	func _ready():#On ready
		HidSto.visible = true#Show this sprite


	func _on_caveHideArea_body_entered(_body):#When entering the body
		#print("BODY ENTERED")#FOR DEBUGGING
		HidSto.visible = false#Hide this sprite



	func _on_caveHideArea_body_exited(_body):#When exiting this body
		HidSto.visible = true#Show this sprite
		
This script is the main script for level one, but only controls the background music

	extends Node2D

	onready var bgM = $bgMusicLevelOne#On ready variable that refers to audio node

	func _ready():#On ready when first entering scene
		bgM.play()#Play audio from this node
		
This is the script for level two

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

This is the script for level three, this script could have been better by dividing up the script into referenced scenes

	extends Node2D

	onready var aA = $attacks/set1/asteroid1Still#This sets an onready variable for all the asteroids(or incoming debris)
	onready var aA2 = $attacks/set1/asteroid1Still2
	onready var aA3 = $attacks/set1/asteroid1Still3
	onready var aA4 = $attacks/set1/asteroid1Still4
	onready var aA5 = $attacks/set1/asteroid1Still5
	onready var aA6 = $attacks/set1/asteroid1Still6
	onready var aA7 = $attacks/set1/asteroid1Still7
	onready var aA8 = $attacks/set1/asteroid1Still8
	onready var aA9 = $attacks/set1/asteroid1Still9
	onready var aA10 = $attacks/set1/asteroid1Still10
	onready var aA11 = $attacks/set1/asteroid1Still11
	onready var aA12 = $attacks/set1/asteroid1Still12
	onready var aA13 = $attacks/set1/asteroid1Still13
	onready var aA14 = $attacks/set1/asteroid1Still14
	onready var aA15 = $attacks/set1/asteroid1Still15
	onready var aA16 = $attacks/set1/asteroid1Still16
	onready var aA17 = $attacks/set1/asteroid1Still17
	onready var aA18 = $attacks/set1/asteroid1Still18
	onready var aA19 = $attacks/set1/asteroid1Still19
	onready var aA20 = $attacks/set1/asteroid1Still20
	onready var aA21 = $attacks/set1/asteroid1Still21
	onready var aA22 = $attacks/set1/asteroid1Still22
	onready var aA23 = $attacks/set1/asteroid1Still23
	onready var aA24 = $attacks/set1/asteroid1Still24
	onready var aA25 = $attacks/set2/asteroid1Still
	onready var aA26 = $attacks/set2/asteroid1Still2
	onready var aA27 = $attacks/set2/asteroid1Still3
	onready var aA28 = $attacks/set2/asteroid1Still4
	onready var aA29 = $attacks/set2/asteroid1Still5
	onready var aA30 = $attacks/set2/asteroid1Still6
	onready var aA31 = $attacks/set2/asteroid1Still7
	onready var aA32 = $attacks/set2/asteroid1Still8
	onready var aA33 = $attacks/set2/asteroid1Still9
	onready var aA34 = $attacks/set2/asteroid1Still10
	onready var aA35 = $attacks/set2/asteroid1Still11
	onready var aA36 = $attacks/set2/asteroid1Still12
	onready var aA37 = $attacks/set2/asteroid1Still13
	onready var aA38 = $attacks/set2/asteroid1Still14
	onready var aA39 = $attacks/set2/asteroid1Still15
	onready var aA40 = $attacks/set2/asteroid1Still16
	onready var aA41 = $attacks/set2/asteroid1Still17
	onready var aA42 = $attacks/set2/asteroid1Still18
	onready var aA43 = $attacks/set2/asteroid1Still19
	onready var aA44 = $attacks/set2/asteroid1Still20
	onready var aA45 = $attacks/set2/asteroid1Still21
	onready var aA46 = $attacks/set2/asteroid1Still22
	onready var aA47 = $attacks/set2/asteroid1Still23
	onready var aA48 = $attacks/set2/asteroid1Still24
	onready var aA49 = $attacks/set2/asteroid1Still
	onready var aA50 = $attacks/set2/asteroid1Still2
	onready var aA51 = $attacks/set2/asteroid1Still3
	onready var aA52 = $attacks/set2/asteroid1Still4
	onready var aA53 = $attacks/set2/asteroid1Still5
	onready var aA54 = $attacks/set2/asteroid1Still6
	onready var aA55 = $attacks/set2/asteroid1Still7
	onready var aA56 = $attacks/set2/asteroid1Still8
	onready var aA57 = $attacks/set2/asteroid1Still9
	onready var aA58 = $attacks/set2/asteroid1Still10
	onready var aA59 = $attacks/set2/asteroid1Still11
	onready var aA60 = $attacks/set2/asteroid1Still12
	onready var aA61 = $attacks/set2/asteroid1Still13
	onready var aA62 = $attacks/set2/asteroid1Still14
	onready var aA63 = $attacks/set2/asteroid1Still15
	onready var aA64 = $attacks/set2/asteroid1Still16
	onready var aA65 = $attacks/set2/asteroid1Still17
	onready var aA66 = $attacks/set2/asteroid1Still18
	onready var aA67 = $attacks/set2/asteroid1Still19
	onready var aA68 = $attacks/set2/asteroid1Still20
	onready var aA69 = $attacks/set2/asteroid1Still21
	onready var aA70 = $attacks/set2/asteroid1Still22
	onready var aA71 = $attacks/set2/asteroid1Still23
	onready var aA72 = $attacks/set2/asteroid1Still24
	onready var lastAsteroid = $attacks/set3/lastasteroid
	signal moveEarth#creates a signal called moveEarth
	onready var bgm = $bgm#onready variable for background music

	var slowasteroid = Vector2(0.0,5.0)#speed variable for slow asteroid
	var mediumasteroid = Vector2(0.0,6.0)#speed varialbe for medium asteroid
	var fastasteroid = Vector2(0.0,7.5)#speed variable for fast asteroid
	# Called when the node enters the scene tree for the first time.
	func _ready():#on ready, called once at the start of Level
		bgm.play()#play background music

	func _process(_delta):
		aA.position += fastasteroid#These lines grab the asteroid variable and give them a speed, a better way to have done this would have been to code the asteroids individually and reference the scenes
		aA2.position += slowasteroid
		aA3.position += mediumasteroid
		aA4.position += slowasteroid
		aA5.position += fastasteroid
		aA6.position += slowasteroid
		aA7.position += mediumasteroid
		aA8.position += slowasteroid
		aA9.position += fastasteroid
		aA10.position += slowasteroid
		aA11.position += mediumasteroid
		aA12.position += fastasteroid
		aA13.position += mediumasteroid
		aA14.position += slowasteroid
		aA15.position += fastasteroid
		aA16.position += slowasteroid
		aA17.position += fastasteroid
		aA18.position += slowasteroid
		aA19.position += mediumasteroid
		aA20.position += slowasteroid
		aA21.position += mediumasteroid
		aA22.position += slowasteroid
		aA23.position += fastasteroid
		aA24.position += slowasteroid
		aA25.position += fastasteroid
		aA26.position += slowasteroid
		aA27.position += mediumasteroid
		aA28.position += slowasteroid
		aA29.position += fastasteroid
		aA30.position += slowasteroid
		aA31.position += mediumasteroid
		aA32.position += slowasteroid
		aA33.position += fastasteroid
		aA34.position += slowasteroid
		aA35.position += mediumasteroid
		aA36.position += fastasteroid
		aA37.position += mediumasteroid
		aA38.position += slowasteroid
		aA39.position += fastasteroid
		aA40.position += slowasteroid
		aA41.position += fastasteroid
		aA42.position += slowasteroid
		aA43.position += mediumasteroid
		aA44.position += slowasteroid
		aA45.position += mediumasteroid
		aA46.position += slowasteroid
		aA47.position += fastasteroid
		aA48.position += slowasteroid
		aA49.position += fastasteroid
		aA50.position += slowasteroid
		aA51.position += mediumasteroid
		aA52.position += slowasteroid
		aA53.position += fastasteroid
		aA54.position += slowasteroid
		aA55.position += mediumasteroid
		aA56.position += slowasteroid
		aA57.position += fastasteroid
		aA58.position += slowasteroid
		aA59.position += mediumasteroid
		aA60.position += fastasteroid
		aA61.position += mediumasteroid
		aA62.position += slowasteroid
		aA63.position += fastasteroid
		aA64.position += slowasteroid
		aA65.position += fastasteroid
		aA66.position += slowasteroid
		aA67.position += mediumasteroid
		aA68.position += slowasteroid
		aA69.position += mediumasteroid
		aA70.position += slowasteroid
		aA71.position += fastasteroid
		aA72.position += slowasteroid
		lastAsteroid.position += slowasteroid
		if lastAsteroid.position == Vector2(400,12500):#when last asteroid reaches this position
			self._moveEarth()#run the moveEarth function

	func _moveEarth():#moveEarth function called once when lastAsteroid reaches a position
		emit_signal("moveEarth")#Emit signal moveEarth
		#print ("emitting signal move earth")##FORDEBUGGING

	func _on_asteroidbody_body_entered(body):#when a body enters asteroid body
		if body.name == "SpaceshipBody2D":#if the name of the body is SpaceshipBody2D
			body.death()#Call for the death function on the body

This script controls the level select controls

	extends Control

	func _ready():
		$VBoxContainer/Menu.grab_focus()#Grab the focus of the button Start(for keyboard navigation)

	func _on_Menu_button_up():#on menu button up
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Menu.tscn")#load this scene
	func _on_LevelOne_button_up():#on LevelOne button up
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Load1.tscn")#load this scene
	func _on_LevelTwo_button_up():#on LevelTwo button up
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Load2.tscn")#load this scene
	func _on_LevelThree_button_up():#on LevelThree button up
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Load3.tscn")#load this scene
	func _input(_event):
		if Input.is_action_pressed("exitToMenu"):#if escape is pressed exit ot menu
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Menu.tscn")
			
This script controls the main menu controls

	extends Control

	func _ready():#On ready when first entering scene
		$VBoxContainer/Start.grab_focus()#Grab the focus of the button Start(for keyboard navigation)

	func _on_Start_button_up():#on releasing this button
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Load1.tscn")#load this scene

	func _on_LevelSelect_button_up():#on releasing this button
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://levelSelect.tscn")#load this scene

	func _on_Credits_button_up():#on releasing this button
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://credits.tscn")#load this scene

	func _on_Quit_button_up():#on releasing this button
		get_tree().quit()#quit the game
		
This script is for the sign areas to show when entered and hide when exited in level one

	extends Area2D

	func _ready():#On ready when first entering scene
		$Label.hide()#hide the child label
	# warning-ignore:unused_argument
	func _on_Area2Dztzi_body_entered(body):#On entering the body
		$Label.show()#Show the child label
	# warning-ignore:unused_argument
	func _on_Area2Dztzi_body_exited(_body):#On exiting the body
		$Label.hide()#Hide child label
		
This script is for the parallax on level one and level two, I found a way to combine scripts without getting an error from missing nodes, this was by doing a name check. if self.name ==

	extends ParallaxLayer

	export var star_speed = -2#variable for our scrolling speed of the background
	export var warp_speed = 1500#warp speed variable
	var warpslowdown = false#warpslowdown variable set to false

	func _process(delta):
		self.motion_offset.x += star_speed * delta#tells itself to move in the x position by delta
		if self.name == "ParallaxLevel3":#if self name is ParallaxLevel3 then move me 1500 on y axis per delta
			self.motion_offset.y += warp_speed * delta
		if warpslowdown == true and self.name == "ParallaxLevel3":#if warpslowdown is true and self name is parallaxLevel3 then lerp warp speed to 0 bt 0.01 per delta
			self.warp_speed = lerp(warp_speed, 0, 0.01)

	func _on_levelThree_moveEarth():#on receiving the signal moveEarth
		warpslowdown = true#changes variable warpslowdown to true

This is the script for the win area

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
		
And lastly but most definitely not least, this is the script for the player

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
			
I think I've covered the main ones here, but I will upload all of them into a folder here too.

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

