extends Control

@onready var app_container: Control = %AppContainer
@onready var home_button: Button = %HomeButton
@onready var call_screen: CallScreen = %CallScreen
@onready var notification_banner: NotificationBanner = %NotificationBanner

@export var home_scene: PackedScene

func _connect_signals() -> void:
	home_button.pressed.connect(func() -> void:
		_open_app(home_scene))
	SignalBus.open_app_requested.connect(_open_app)
	SignalBus.open_webpage_requested.connect(_open_webpage)
	PlayerData.call_registered.connect(_on_call_registered)
	PlayerData.notification_requested.connect(_on_notification_requested)


func _ready() -> void:
	_connect_signals()


func _open_app(scene: PackedScene) -> Node:
	_clear_app_container()
	
	var new_app := scene.instantiate()
	app_container.add_child(new_app)
	return new_app


func _clear_app_container() -> void:
	for child in app_container.get_children():
		child.queue_free()


func _open_webpage(webpage: WebpageData) -> void:
	const WEB_BROWSER_SCENE = preload("uid://c15x2ptcs1e2l")
	var browser := _open_app(WEB_BROWSER_SCENE) as WebBrowserApp
	browser.navigate_to_page(webpage)
	PlayerData.unlock_webpage(webpage)


func _on_call_registered(contact: ContactData, audio: AudioStream) -> void:
	call_screen.start_call(contact, audio)


func _on_notification_requested(notification_data: NotificationData) -> void:
	notification_banner.show_notification(notification_data)
