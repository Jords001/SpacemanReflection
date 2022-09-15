extends Camera2D
onready var deathSp = $deathSprite #onready variable for deathsprite

func _ready():#function ready called once at the start of a level
	deathSp.visible = false#hide death UI

func _on_SpaceshipBody2D_showdeathUI():#upon receiving the signal show death UI
	deathSp.visible = true#show death UI
