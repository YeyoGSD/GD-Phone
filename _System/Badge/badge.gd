class_name Badge
extends Control

@onready var number_label: Label = %NumberLabel

var current_count := 0


func set_count(count: int) -> void:
	if count <= 0:
		current_count = 0
		hide()
		return
	
	current_count = count
	
	if current_count <= 99:
		number_label.text = str(current_count)
	else:
		number_label.text = '99+'
	show()
