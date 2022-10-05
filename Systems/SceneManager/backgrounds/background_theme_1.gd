extends Node2D

func _physics_process(_delta):
	$ParallaxBackground/MoonAndCloudsLayer.motion_offset.x -= .03
	$ParallaxBackground/GreyBuilding3Layer.motion_offset.x -= .1
	$ParallaxBackground/GrayBuilding2Layer.motion_offset.x -= .2
	$ParallaxBackground/GrayBuilding1Layer.motion_offset.x -= .3
	$ParallaxBackground/ColorBuildingsLayer.motion_offset.x -= .6
	$ParallaxBackground/TreesAndGroundLayer.motion_offset.x -= .8
