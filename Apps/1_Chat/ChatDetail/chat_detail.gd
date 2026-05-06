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


func setup(chat_data: ChatData) -> void:
	name_label.text = chat_data.contact.name
	
	if chat_data.contact.avatar:
		avatar.texture = chat_data.contact.avatar
	
	for child in messages_container.get_children():
		child.queue_free()
	
	for msg in chat_data.conversation:
		_add_message_bubble(msg)
	
	_scroll_to_bottom()

func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	type_box.text_submitted.connect(_on_text_submitted)
	send_button.pressed.connect(_on_send_pressed)


func _add_message_bubble(msg_data: MessageData) -> void:
	var bubble: ChatBubble
	
	if msg_data.sender == MessageData.Sender.ME:
		bubble = BUBBLE_ME.instantiate() as ChatBubble
	else:
		bubble = BUBBLE_OTHER.instantiate() as ChatBubble
	
	messages_container.add_child(bubble)
	bubble.setup(msg_data.text, msg_data.audio, msg_data.image, msg_data.link)
	
	if not msg_data.reply_options.is_empty():
		_show_options(msg_data.reply_options)
	
	if msg_data.on_read_event:
		EventManager.execute(msg_data.on_read_event)


func _trigger_npc_reply(message: MessageData) -> void:
	# TODO: Agregar animación de escribiendo
	await get_tree().create_timer(message.delay).timeout
	_add_message_bubble(message)
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
	_add_message_bubble(new_msg)
	
	type_box.text = ""
	
	_scroll_to_bottom()


func _on_option_selected(option: ReplyOption) -> void:
	var msg := _create_message(option.text, MessageData.Sender.ME)
	
	_add_message_bubble(msg)
	_scroll_to_bottom()
	
	choice_input_container.hide()
	keyboard_input_container.show()
	
	if option.target_message:
		_trigger_npc_reply(option.target_message)
	else:
		print("Fin de la conversación (No hay target_message)")


func _on_back_button_pressed() -> void:
	requested_go_back.emit()


func _on_text_submitted() -> void:
	_on_send_pressed()
