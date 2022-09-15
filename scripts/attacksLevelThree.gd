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
