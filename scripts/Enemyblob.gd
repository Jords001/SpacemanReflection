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
	
