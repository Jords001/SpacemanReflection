extends Area2D
onready var mS = $mineSprite#onready var for mineSprite
onready var mAu = $mineAudio#onready var for mineAudio
var mineexplodedtime = 1.24#time for the mine explode sound to finish before culling

func _ready():#onready, called once at the start of the level
	mS.play("mineidle")

func _on_mineArea2D_body_entered(body):#on body entering area
	body.deathtype = 2#call for deathtype to be change to 2 in body
	body.death()#call for function death to be run in body
	$CollisionShape2D.queue_free()#cull node collisionshape
	mS.stop()#stop mine sprite animating
	mS.play("mineexplode")#play mine explode animation
	mAu.play()#play mine exploded audio
	yield(get_tree().create_timer(mineexplodedtime),"timeout")#wait 1.24 seconds
	queue_free()#queue node and children to be freed/culled
