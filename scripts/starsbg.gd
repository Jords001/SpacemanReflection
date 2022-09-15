extends ParallaxLayer

export var star_speed = -2#variable for our scrolling speed of the background
export var warp_speed = 1500#warp speed variable
var warpslowdown = false#warpslowdown variable set to false

func _process(delta):
	self.motion_offset.x += star_speed * delta#tells itself to move in the x position by delta
	if self.name == "ParallaxLevel3":#if self name is ParallaxLevel3 then move me 1500 on y axis per delta
		self.motion_offset.y += warp_speed * delta
	if warpslowdown == true and self.name == "ParallaxLevel3":#if warpslowdown is true and self name is parallaxLevel3 then lerp warp speed to 0 bt 0.01 per delta
		self.warp_speed = lerp(warp_speed, 0, 0.01)

func _on_levelThree_moveEarth():#on receiving the signal moveEarth
	warpslowdown = true#changes variable warpslowdown to true
