extends Area2D

onready var fS = $fireSprite#On ready variable that refers to Sprite node
onready var fAu = $fireAudio#On ready variable that refers to Audio node

func _ready():#On ready when first entering scene
	fS.play("fire")#play sprite animation fire
	fAu.play ()#play audio from this node

func _on_fireArea2D_body_entered(body):#on body entering area
	body.deathtype = 2#call for deathtype variable change to 2 in body
	body.death()#call for death function in body
