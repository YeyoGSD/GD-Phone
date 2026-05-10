class_name StoryEvent
extends Resource

enum Type {
	INCOMING_CALL,
	UNLOCK_PHOTO,
	NOTIFICATION,
	UNLOCK_CHAT,
	UNLOCK_WEBPAGE,
}

@export var type: Type
@export var delay: float
@export var target_resource: Resource 
