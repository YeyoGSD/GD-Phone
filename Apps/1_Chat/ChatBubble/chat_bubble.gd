class_name ChatBubble
extends PanelContainer

@onready var message_label: Label = %MessageLabel
@onready var photo_rect: TextureRect = %PhotoRect
@onready var audio_player: AudioStreamPlayer = %AudioPlayer
@onready var audio_ui: HBoxContainer = %AudioUI
@onready var play_button: Button = $Content/AudioUI/PlayButton
@onready var audio_slider: HSlider = %AudioSlider
@onready var link_button: Button = %LinkButton

@onready var max_allowed_width: float = get_viewport_rect().size.x * 0.75

const MEDIA_PAUSE_ICON := preload("uid://c3q11d80ei1d3")
const MEDIA_PLAY_ICON := preload("uid://cgvlgswhkb262")

var link_data: WebpageData
var saved_playback_pos: float = 0.0
var is_dragging_slider: bool = false


func setup(msg: String, audio: AudioStream, photo:Texture2D, webpage_data: WebpageData) -> void:
	message_label.text = msg
	photo_rect.texture = photo
	audio_player.stream = audio
	link_data = webpage_data
	
	_handle_label_autowrap()
	_handle_photo_logic()
	_handle_audio_player_logic()
	_handle_link_logic()


func _ready() -> void:
	set_process(false)
	_connect_signals()


func _connect_signals() -> void:
	play_button.pressed.connect(_on_play_toggled)
	audio_player.finished.connect(_on_audio_finished)
	audio_slider.drag_started.connect(_on_slider_drag_started)
	audio_slider.drag_ended.connect(_on_slider_drag_ended)
	link_button.pressed.connect(_on_link_pressed)


func _process(_delta: float) -> void:
	if audio_player.playing and not is_dragging_slider:
		audio_slider.value = audio_player.get_playback_position()


func _handle_label_autowrap() -> void:
	if message_label.text.is_empty():
		message_label.hide()
		return
	
	var font := message_label.get_theme_font("font")
	var font_size := message_label.get_theme_font_size("font_size")
	var text_size := font.get_string_size(message_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	
	if text_size.x > max_allowed_width:
		message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		message_label.custom_minimum_size.x = max_allowed_width
	else:
		message_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		message_label.custom_minimum_size.x = 0


func _handle_photo_logic() -> void:
	if photo_rect.texture == null:
		photo_rect.hide()
		return
	
	var img_size := photo_rect.texture.get_size()
	var aspect := img_size.y / img_size.x
	
	photo_rect.custom_minimum_size.x = max_allowed_width
	photo_rect.custom_minimum_size.y = max_allowed_width * aspect


func _handle_audio_player_logic() -> void:
	if audio_player.stream == null:
		audio_ui.hide()
		return
	
	audio_ui.custom_minimum_size.x = max_allowed_width
	
	audio_slider.max_value = audio_player.stream.get_length()


func _handle_link_logic() -> void:
	if link_data == null:
		link_button.hide()
		return
	
	link_button.icon = link_data.icon
	link_button.text = link_data.title


func _on_play_toggled() -> void:
	if play_button.button_pressed:
		audio_player.play(saved_playback_pos)
		play_button.icon = MEDIA_PAUSE_ICON
		set_process(true)
	else:
		audio_player.stop()
		play_button.icon = MEDIA_PLAY_ICON
		set_process(false)


func _on_audio_finished() -> void:
	play_button.button_pressed = false
	play_button.icon = MEDIA_PLAY_ICON


func _on_slider_drag_started() -> void:
	is_dragging_slider = true


func _on_slider_drag_ended(_value_changed: bool) -> void:
	is_dragging_slider = false
	saved_playback_pos = audio_slider.value
	
	if play_button.button_pressed:
		audio_player.play(saved_playback_pos)


func _on_link_pressed() -> void:
	SignalBus.open_webpage_requested.emit(link_data)
