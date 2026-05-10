class_name ChatList
extends Control

signal requested_open_chat(data: ChatData)

@export var chat_row_scene: PackedScene

@onready var chats_container: VBoxContainer = %ChatsContainer

func _ready() -> void:
	PlayerData.chat_unlocked.connect(_create_row)
	_load_unlocked_chats()


func _load_unlocked_chats() -> void:
	for child in chats_container.get_children():
		child.queue_free()
	
	for chat in PlayerData.unlocked_chats:
		_create_row(chat)


func _create_row(data: ChatData) -> void:
	var new_row := chat_row_scene.instantiate() as ChatRow
	chats_container.add_child(new_row)
	new_row.setup(data)
	new_row.chat_selected.connect(_on_chat_selected)


func _on_chat_selected(chat: ChatData) -> void:
	requested_open_chat.emit(chat)
