extends Node

signal photo_unlocked(new_photo: PhotoData)
signal webpage_unlocked(new_webpage: WebpageData)
signal chat_unlocked(new_chat: ChatData)

var unlocked_photos: Array[PhotoData]
var unlocked_webpages: Array[WebpageData]
var unlocked_chats: Array[ChatData] = [
	preload("uid://clov4e5f75fxj"),
]


func add_photo(photo: PhotoData) -> void:
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
