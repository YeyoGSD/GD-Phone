class_name GalleryList
extends Control

const THUMBNAIL_SCENE = preload("uid://bco2f5tc6jwnu")

signal requested_view_photo(photo_data: PhotoData)

@onready var margin_container: MarginContainer = %MarginContainer
@onready var photo_grid: GridContainer = %PhotoGrid


func _ready() -> void:
	PlayerData.photo_unlocked.connect(_create_thumbnail)
	_load_unlocked_photos()


func _load_unlocked_photos() -> void:
	for child in photo_grid.get_children():
		child.queue_free()
	
	for photo_data in PlayerData.unlocked_photos:
		_create_thumbnail(photo_data)


func _get_cell_width() -> float:
	const SIDE_MARGINS: int = 2
	var columns := photo_grid.columns
	var screen_width := get_parent_area_size().x
	var margins_width :=  margin_container.get_theme_constant(&"margin_left") * SIDE_MARGINS
	var grid_separation := photo_grid.get_theme_constant(&"h_separation") * (columns - 1)
	return (screen_width - margins_width - grid_separation) / columns


func _create_thumbnail(photo_data: PhotoData) -> void:
	var thumb := THUMBNAIL_SCENE.instantiate() as PhotoThumbnail
	photo_grid.add_child(thumb)
	thumb.setup(photo_data, _get_cell_width())
	thumb.pressed.connect(func() -> void:
		requested_view_photo.emit(photo_data))
