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
 
 I wanted to make some collectibles for a mission purpose. My first problem was trying to add it to an item that clears itself and is a unique instance. I also initially had a seperate script for the animation like so.
 
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
