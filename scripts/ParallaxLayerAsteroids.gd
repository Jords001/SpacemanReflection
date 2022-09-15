extends ParallaxLayer

var asteroid_speed = -10#variable for asteroid scrolling speed

onready var abg1 = $asteroid1Sbg/asteroid1bg#onready variable for all background asteroids
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

func _process(delta):#process function runs on delta by default
	self.motion_offset.x += asteroid_speed * delta#on delta move asteroids x -10
	abg1.rotation_degrees += 2#these are the different rotations which are all performed on delta
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
