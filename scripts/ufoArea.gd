extends Area2D
var ufoactive = 1#sets ufo active to 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$forceField.play("on")
	$forceFieldAu.play()

func _on_ufoArea2D_body_entered(body):#upon entering the body if ufoactive is 1 pull the other body up by -1000 velocity
	if ufoactive == 1:
		body.velocity.y = -1000
	else:
		pass

func _on_ufoDeactivateArea2D_body_entered(_input):#upon entering body hide the cutaway and show the label
	$UFOcutaway.visible = false
	$Label.show()

func _on_ufoDeactivateArea2D_body_exited(_body):#upon exiting the body show the cutaway and hide the label
	$UFOcutaway.visible = true
	$Label.hide()

func _on_levelTwo_ufodeactivated():#upon receiving the signal ufodeactivated set ufo active to 0 stop the forcefield audio loop and sprite and play the forcefield deactivated audio and hide the abduction ray
	ufoactive = 0
	$forceField.play("off")
	$forceFieldAu.stop()
	$forceFieldAuDe.play()
	$abductionRay.visible = false
