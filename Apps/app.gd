class_name App
extends Control

enum Type {
	NONE,
	CHAT,
	GALLERY,
	WEB_BROWSER,
}

@export var app_type: Type = Type.NONE


func _ready() -> void:
	if app_type != Type.NONE:
		PlayerData.reset_unread_notifications_count(app_type)
	_on_app_ready()


func _on_app_ready() -> void:
	pass
