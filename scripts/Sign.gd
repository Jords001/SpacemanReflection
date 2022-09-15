extends Area2D

func _ready():#On ready when first entering scene
	$Label.hide()#hide the child label
# warning-ignore:unused_argument
func _on_Area2Dztzi_body_entered(body):#On entering the body
	$Label.show()#Show the child label
# warning-ignore:unused_argument
func _on_Area2Dztzi_body_exited(_body):#On exiting the body
	$Label.hide()#Hide child label
