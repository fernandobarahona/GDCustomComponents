extends Node2D

func _physics_process(_delta):
	$ParallaxBackground/MoonCloundBkLayer.motion_offset.x -= .12
	$ParallaxBackground/StarsLayer.motion_offset.x -= .08
	$ParallaxBackground/Trees3Layer.motion_offset.x -= .2
	$ParallaxBackground/Trees2Layer.motion_offset.x -= .3
	$ParallaxBackground/Trees1Layer.motion_offset.x -= .4
	$ParallaxBackground/GroundLayer.motion_offset.x -= .8
