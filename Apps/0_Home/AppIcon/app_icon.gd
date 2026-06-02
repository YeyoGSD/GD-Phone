class_name AppIcon
extends Button

@export var app_definition: AppDefinition

@onready var badge: Badge = %Badge

func _ready() -> void:
	_update_badge()
	pressed.connect(func() -> void:
		SignalBus.open_app_requested.emit(app_definition))
	PlayerData.unread_notifications_count_changed.connect(_update_badge)


func _update_badge() -> void:
	if app_definition:
		badge.set_dot(PlayerData.has_unread_for_app(app_definition))
	else:
		badge.set_dot(false)
	
