extends App

@onready var chat_list: ChatList = $ChatList
@onready var chat_detail: ChatDetail = $ChatDetail


func _on_app_ready() -> void:
	chat_detail.requested_go_back.connect(func() -> void:
		chat_list.show()
		chat_detail.hide())
	
	chat_list.requested_open_chat.connect(func(data: ChatData) -> void:
		chat_detail.setup(data)
		chat_detail.show()
		chat_list.hide())
