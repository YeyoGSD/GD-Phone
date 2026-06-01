class_name AppIcon
extends Button

@export var app_scene: PackedScene
@export var app: App.Type

@onready var badge: Badge = %Badge

func _ready() -> void:
	_update_badge()
	pressed.connect(func() -> void:
		SignalBus.open_app_requested.emit(app_scene))
	PlayerData.unread_notifications_count_changed.connect(_update_badge)


func _update_badge() -> void:
	var count: int
	if app == App.Type.CHAT:
		count = PlayerData.get_total_unread_messages_count()
	else:
		count = PlayerData.get_unread_notification_count(app)
	badge.set_count(count)
