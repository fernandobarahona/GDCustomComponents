extends Node2D

onready var timer_total_time = $CircularCountDown.total_time

func _ready():
	$LabelTiempo.text = str(timer_total_time)

func _on_RoundPlus_button_down():
	timer_total_time += 1
	$CircularCountDown.total_time = timer_total_time
	$LabelTiempo.text = str(timer_total_time)

func _on_RoundMinus_button_down():
	if(timer_total_time > 1):
		timer_total_time -= 1
		$CircularCountDown.total_time = timer_total_time
		$LabelTiempo.text = str(timer_total_time)

