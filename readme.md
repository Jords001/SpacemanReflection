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
 
