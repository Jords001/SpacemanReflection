Monday 5th September

This is the documentation for the game I started developing on the Godot engine consisting of Gd script.

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
