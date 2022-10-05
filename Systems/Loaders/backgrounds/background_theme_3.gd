extends Node2D

func _physics_process(_delta):
	$ParallaxBackground/ParallaxLayer.motion_offset.x -= 0
	$ParallaxBackground/ParallaxLayer2.motion_offset.x -= .08
	$ParallaxBackground/ParallaxLayer3.motion_offset.x -= .2
	$ParallaxBackground/ParallaxLayer4.motion_offset.x -= .3
	$ParallaxBackground/ParallaxLayer5.motion_offset.x -= .4
