extends Node

signal photo_unlocked(new_photo: PhotoData)
signal webpage_unlocked(new_webpage: WebpageData)
signal chat_unlocked(new_chat: ChatData)
signal call_registered(new_call: ContactData, audio: AudioStream)
signal notification_requested(new_notifiction: NotificationData)

@export var unlocked_photos: Array[PhotoData]
@export var unlocked_webpages: Array[WebpageData]
@export var unlocked_chats: Array[ChatData]
@export var call_history: Array[ContactData]


func send_notification(noti: NotificationData) -> void:
	notification_requested.emit(noti)


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
