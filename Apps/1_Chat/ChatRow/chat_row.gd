class_name ChatRow
extends Button

signal chat_selected(chat_data: ChatData)

@onready var avatar: TextureRect = %Avatar
@onready var name_label: Label = %NameLabel
@onready var preview_label: Label = %PreviewLabel

var chat_data: ChatData

func setup(data: ChatData) -> void:
	chat_data = data
	name_label.text = data.contact.name
	
	if data.contact.avatar:
		avatar.texture = data.contact.avatar
	
	if not data.intial_conversation.is_empty():
		var last_msg := data.intial_conversation[-1]
		preview_label.text = last_msg.text


func _pressed() -> void:
	chat_selected.emit(chat_data)
