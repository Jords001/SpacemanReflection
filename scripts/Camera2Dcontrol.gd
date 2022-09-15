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
