extends App

@onready var gallery_list: GalleryList = %GalleryList
@onready var photo_viewer: PhotoViewer = %PhotoViewer

func _ready() -> void:
	gallery_list.requested_view_photo.connect(func(photo_data: PhotoData) -> void:
		photo_viewer.setup(photo_data)
		photo_viewer.show()
		gallery_list.hide())
	
	photo_viewer.requested_go_back.connect(func() -> void:
		gallery_list.show()
		photo_viewer.hide())
