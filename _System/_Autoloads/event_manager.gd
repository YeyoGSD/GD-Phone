extends Node

func execute(event: StoryEvent) -> void:
	if event.delay > 0:
		await get_tree().create_timer(event.delay).timeout
	
	match event.type:
		StoryEvent.Type.INCOMING_CALL:
			var contact := event.target_resource as ContactData
			if not contact:
				push_error("The Incoming Call event must have a target resource of type ContactData")
				return
			
			PlayerData.register_call(contact, null)
			
		StoryEvent.Type.UNLOCK_PHOTO:
			var photo := event.target_resource as PhotoData
			if not photo:
				push_error("The Unlock Photo event must have a target resource of type PhotoData")
				return
			
			PlayerData.unlock_photo(photo)
			
		StoryEvent.Type.NOTIFICATION:
			var noti := event.target_resource as NotificationData
			if not noti:
				push_warning("The Notification event must have a target resource of type NotificationData")
				return
			
			PlayerData.send_notification(noti)
			
		StoryEvent.Type.UNLOCK_CHAT:
			var chat := event.target_resource as ChatData
			if not chat:
				push_warning("The UnlockChat event must have a target resource of type ChatData")
				return
			
			PlayerData.unlock_chat(chat)
			
		StoryEvent.Type.UNLOCK_WEBPAGE:
			var webpage := event.target_resource as WebpageData
			if not webpage:
				push_warning("The UnlockWebpage event must have a target resource of type WebpageData")
				return
			
			PlayerData.unlock_webpage(webpage)
