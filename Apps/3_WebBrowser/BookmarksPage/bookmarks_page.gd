class_name BookmarksPage
extends WebPage

@onready var bookmarks_grid: GridContainer = %BookmarksGrid

@export var bookmark_tile_scene: PackedScene


func _ready() -> void:
	PlayerData.webpage_unlocked.connect(_create_bookmark_tile)
	_load_unlocked_webpages()


func _load_unlocked_webpages() -> void:
	for child in bookmarks_grid.get_children():
		child.queue_free()
	
	for webpage in PlayerData.unlocked_webpages:
		_create_bookmark_tile(webpage)


func _create_bookmark_tile(webpage: WebpageData) -> void:
	var tile := bookmark_tile_scene.instantiate() as BookmarkTile
	bookmarks_grid.add_child(tile)
	tile.setup(webpage.icon, webpage.title)
	tile.pressed.connect(func() -> void:
		navigate_to_url_requested.emit(webpage.url))
