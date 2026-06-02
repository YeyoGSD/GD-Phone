extends Node

signal photo_unlocked(new_photo: PhotoData)
signal webpage_unlocked(new_webpage: WebpageData)
signal chat_unlocked(new_chat: ChatData)
signal call_registered(new_call: ContactData, audio: AudioStream)
signal notification_requested(new_notifiction: NotificationData)
signal new_message_registered(chat: ChatData, msg: MessageData)
signal unread_notifications_count_changed()

var call_history: Array[ContactData]
var chats_history: Dictionary[ChatData, Array]
var unread_chats_messages: Dictionary[ChatData, int]
var unread_app_flags: Dictionary[AppDefinition, bool]
var active_chat: ChatData

var chat_app_definition: AppDefinition = preload("uid://cy2uw8ysi3bvc")
var unlocked_chats: Array[ChatData] = [
	preload("uid://clov4e5f75fxj"),
]
var unlocked_photos: Array[PhotoData] = [
	preload("uid://vfatcsi11l20"),
]
var unlocked_webpages: Array[WebpageData] = [
	preload("uid://da6j7k6txtj65"),
]

func has_unread_for_app(app_def: AppDefinition) -> bool:
	return unread_app_flags.get(app_def, false)


func get_unread_messages_count(chat: ChatData) -> int:
	return unread_chats_messages.get(chat, 0)


func get_total_unread_messages_count() -> int:
	var total := 0
	for count: int in unread_chats_messages.values():
		total += count
	return total


func mark_chat_as_read(chat: ChatData) -> void:
	unread_chats_messages[chat] = 0
	if get_total_unread_messages_count() == 0:
		unread_app_flags.erase(chat_app_definition)
	unread_notifications_count_changed.emit()


func reset_app_notification(app_def: AppDefinition) -> void:
	if app_def == chat_app_definition:
		return
	
	if unread_app_flags.erase(app_def):
		unread_notifications_count_changed.emit()


func get_or_add_chat_history(chat: ChatData, initial_messages: Array[MessageData]) -> Array[MessageData]:
	return chats_history.get_or_add(chat, initial_messages.duplicate())


func get_last_message_from_chat(chat: ChatData) -> MessageData:
	if chats_history.has(chat):
		return chats_history.get(chat)[-1]
	return null


func register_new_message(chat: ChatData, message: MessageData) -> void:
	var history := get_or_add_chat_history(chat, chat.intial_conversation)
	history.append(message)
	new_message_registered.emit(chat, message)
	
	if active_chat == chat or message.sender == MessageData.Sender.ME:
		return
	
	unread_chats_messages[chat] = unread_chats_messages.get(chat, 0) + 1
	unread_app_flags[chat_app_definition] = true
	unread_notifications_count_changed.emit()


func send_notification(noti: NotificationData) -> void:
	if not noti.app_target:
		return
	
	notification_requested.emit(noti)
	unread_app_flags[noti.app_target] = true
	unread_notifications_count_changed.emit()


func register_call(contact: ContactData, audio: AudioStream) -> void:
	call_history.append(contact)
	call_registered.emit(contact, audio)


func unlock_photo(photo: PhotoData) -> void:
	if not photo in unlocked_photos:
		unlocked_photos.append(photo)
		photo_unlocked.emit(photo)


func unlock_webpage(webpage: WebpageData) -> void:
	if not webpage in unlocked_webpages:
		unlocked_webpages.append(webpage)
		webpage_unlocked.emit(webpage)


func unlock_chat(chat: ChatData) -> void:
	if not chat in unlocked_chats:
		unlocked_chats.append(chat)
		chat_unlocked.emit(chat)
