extends Resource
class_name NotificationData

@export var title: String
@export_multiline var content: String
@export var icon: Texture2D
@export var sound: AudioStream
@export var duration: float = 3.0
@export var app_target: App.Type
