class_name ChatRow
extends Button

signal chat_selected(chat_data: ChatData)

@onready var avatar: TextureRect = %Avatar
@onready var name_label: Label = %NameLabel
@onready var preview_label: Label = %PreviewLabel

var chat: ChatData

func setup(data: ChatData) -> void:
	chat = data
	name_label.text = data.contact.name
	
	if data.contact.avatar:
		avatar.texture = data.contact.avatar
	
	var last_msg := PlayerData.get_last_message_from_chat(data)
	if last_msg:
		preview_label.text = last_msg.text


func _ready() -> void:
	PlayerData.new_message_registered.connect(func (chat_updated: ChatData, msg: MessageData) ->void:
		if chat_updated == chat:
			_update_preview(msg))


func _update_preview(last_message: MessageData) -> void:
	preview_label.text = last_message.text


func _pressed() -> void:
	chat_selected.emit(chat)
