extends Control

onready var _timer:Timer = $Timer
onready var _circular_progress_bar = $CircularProgressBar

export(float) onready var total_time:float setget _set_total_time

func _ready() -> void:
	_set_total_time(total_time)

func _set_total_time(new_time):
	total_time = new_time
	
	if (self.is_inside_tree()):
		_timer.wait_time = total_time
		_circular_progress_bar.value = total_time
		_circular_progress_bar.max_value = total_time
		restart_timer()

func restart_timer():
	_timer.start()

func _physics_process(_delta):
	_circular_progress_bar.value = _timer.time_left
