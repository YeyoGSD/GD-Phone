class_name ChatDetail
extends Control

signal requested_go_back

@onready var messages_container: VBoxContainer = %MessagesContainer
@onready var name_label: Label = %NameLabel
@onready var back_button: Button = %BackButton
@onready var avatar: TextureRect = %Avatar
@onready var message_scroll: ScrollContainer = %MessageScroll
@onready var type_box: LineEdit = %TypeBox
@onready var send_button: Button = %SendButton
@onready var keyboard_input_container: HBoxContainer = %KeyboardInputContainer
@onready var choice_input_container: HBoxContainer = %ChoiceInputContainer

const BUBBLE_ME = preload("uid://cnmccr7wi7o5r")
const BUBBLE_OTHER = preload("uid://dcqg1uuswi4y8")

var current_chat: ChatData


func setup(data: ChatData) -> void:
	PlayerData.active_chat = data
	current_chat = data
	name_label.text = data.contact.name
	
	if data.contact.avatar:
		avatar.texture = data.contact.avatar
	
	for child in messages_container.get_children():
		child.queue_free()
	
	var chat := PlayerData.get_or_add_chat_history(data, data.intial_conversation)
	if chat.is_empty():
		return
	for msg in chat:
		_add_message_bubble(msg)
	if not chat[-1].reply_options.is_empty():
		_show_options(chat[-1].reply_options)
	
	_scroll_to_bottom()
	PlayerData.mark_chat_as_read(current_chat)


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	type_box.text_submitted.connect(func (_new_text: String) -> void:
		_on_text_submitted())
	send_button.pressed.connect(_on_send_pressed)
	PlayerData.new_message_registered.connect(func (chat: ChatData, msg: MessageData) -> void:
		if chat == current_chat:
			_add_message_bubble(msg))


func _exit_tree() -> void:
	PlayerData.active_chat = null


func _add_message_bubble(msg_data: MessageData) -> void:
	var bubble: ChatBubble
	
	if msg_data.sender == MessageData.Sender.ME:
		bubble = BUBBLE_ME.instantiate() as ChatBubble
	else:
		bubble = BUBBLE_OTHER.instantiate() as ChatBubble
	
	messages_container.add_child(bubble)
	bubble.setup(msg_data.text, msg_data.audio, msg_data.image, msg_data.link)
	
	if msg_data.is_read:
		return
	
	if msg_data.on_read_event:
		EventManager.execute(msg_data.on_read_event)
	
	msg_data.is_read = true


func _register_message(msg: MessageData) -> void:
	PlayerData.register_new_message(current_chat, msg)


func _trigger_npc_reply(message: MessageData) -> void:
	# TODO: Agregar animación de escribiendo
	await get_tree().create_timer(message.delay).timeout
	_register_message(message)
	_scroll_to_bottom()
	
	if message.next_message_auto:
		_trigger_npc_reply(message.next_message_auto)
	elif not message.reply_options.is_empty():
		_show_options(message.reply_options)


func _show_options(options: Array[ReplyOption]) -> void:
	keyboard_input_container.hide()
	choice_input_container.show()
	
	for child in choice_input_container.get_children():
		child.queue_free()
	
	for option in options:
		var btn := Button.new()
		btn.custom_minimum_size.x = 150
		btn.text = option.text
		btn.pressed.connect(_on_option_selected.bind(option))
		choice_input_container.add_child(btn)


func _scroll_to_bottom() -> void:
	# Wait one frame to let Godot recalculate the size of the new bubble
	await get_tree().process_frame
	message_scroll.set_deferred(&"scroll_vertical", message_scroll.get_v_scroll_bar().max_value )


func _create_message(text: String, sender: MessageData.Sender) -> MessageData:
	var msg := MessageData.new()
	msg.text = text
	msg.sender = sender
	return msg


func _on_send_pressed() -> void:
	var text := type_box.text.strip_edges()
	if text.is_empty():
		return
	
	var new_msg := _create_message(text, MessageData.Sender.ME)
	_register_message(new_msg)
	
	type_box.text = ""
	
	_scroll_to_bottom()


func _on_option_selected(option: ReplyOption) -> void:
	var msg := _create_message(option.text, MessageData.Sender.ME)
	
	_register_message(msg)
	_scroll_to_bottom()
	
	choice_input_container.hide()
	keyboard_input_container.show()
	
	if option.target_message:
		_trigger_npc_reply(option.target_message)
	else:
		print("Fin de la conversación (No hay target_message)")


func _on_back_button_pressed() -> void:
	PlayerData.active_chat = null
	requested_go_back.emit()


func _on_text_submitted() -> void:
	_on_send_pressed()
