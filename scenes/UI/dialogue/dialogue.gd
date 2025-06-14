extends VBoxContainer

@export var dialogue_gdscript : GDScript = null
var dialogue_engine : DialogueEngine = null

@onready var animation_player : AnimationPlayer = find_child("AnimationPlayer")

const dialogue_box_scene = preload("res://scenes/UI/dialogue/dialogue_box.tscn")

@onready var clicking_audio: AudioStreamPlayer2D = $ClickingAudio

#func _ready() -> void:

func begin():
	dialogue_engine = dialogue_gdscript.new()
	dialogue_engine.dialogue_started.connect(__on_dialogue_started)
	dialogue_engine.dialogue_continued.connect(__on_dialogue_continued)
	dialogue_engine.dialogue_finished.connect(__on_dialogue_finished)
	dialogue_engine.dialogue_canceled.connect(__on_dialogue_canceled)

func _input(p_input_event : InputEvent) -> void:
	if p_input_event.is_action_pressed(&"ui_accept"):
		if not animation_player.is_playing():
			dialogue_engine.advance()
		else:
			# Player is impatient -- auto-advance the text
			var animation_name : StringName = animation_player.get_current_animation()
			var animation : Animation = animation_player.get_animation(animation_name)
			animation_player.advance(animation.get_length()) # this will fire the animation_finished signal automatically
		accept_event() # accepting input event here to stop it from traversing into into buttons possibly added through the interaction


func __on_dialogue_started() -> void:
	print("Dialogue Started!")


func __on_dialogue_continued(p_dialogue_entry : DialogueEntry) -> void:
	# Add the text to the log:
	var label = $RichTextLabel
	label.set_use_bbcode(true)
	label.set_fit_content(true)
	if p_dialogue_entry.has_metadata("author"):
		var author : String = p_dialogue_entry.get_metadata("author")
		Globals.current_speaker = author
		label.set_text("  > " + p_dialogue_entry.get_formatted_text())
	else:
		assert(false, "Provide an author for every dialogue")
	#add_child(label, true)

	# Setup the animation:
	animation_player.stop(true) # internally some timers do not reset properly unless we do this
	if not animation_player.has_animation_library(&"demo"):
		var new_animation_library : AnimationLibrary = AnimationLibrary.new()
		animation_player.add_animation_library(&"demo", new_animation_library)
	var animation_library : AnimationLibrary = animation_player.get_animation_library(&"demo")
	var animation : Animation = create_visible_characters_animation_per_character(label.get_text(), 0.045, true)
	animation_player.set_root_node(label.get_path())
	animation_library.add_animation(&"dialogue", animation)
	animation_player.play(&"demo/dialogue")


func __on_dialogue_finished() -> void:
	print("Dialogue Exited!")
	Globals.dialogue_active = false
	Globals.dialogue_stages[Globals.dialogue_scene] = Globals.DONE
	Globals.dialogue_scene = ""
	Globals.dialogue_index += 1

func __on_dialogue_canceled() -> void:
	print("Dialogue Canceled!")
	Globals.dialogue_active = false
	Globals.dialogue_stages[Globals.dialogue_scene] = Globals.DONE
	Globals.dialogue_scene = ""
	Globals.dialogue_index += 1

func __on_animation_started(p_animation_name : StringName) -> void:
	print("Animation started:", p_animation_name)

func __on_animation_finished(p_animation_name : StringName, p_post_dialogue_callback : Callable) -> void:
	if p_animation_name == &"demo/dialogue":
		p_post_dialogue_callback.call()

# Utility function to animate the text at a constant speed
func create_visible_characters_animation_per_character(p_text : String, p_time_per_character : float, p_instant_first_character : bool = false, p_time_whitespace : bool = false)  -> Animation:
	# Do initial calculations
	var whitespace_regex : RegEx
	if not p_time_whitespace or p_instant_first_character:
		whitespace_regex = RegEx.new()
		whitespace_regex.compile("\\s")

	# Create animation and track
	var animation : Animation = Animation.new()
	var track_index : int = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ".:visible_characters")
	animation.track_set_interpolation_type(track_index, Animation.INTERPOLATION_LINEAR)

	# Play audio
	clicking_audio.play()

	# Configure keys
	var total_time : float = 0.0
	var total_visible_characters : int = 0
	var whitespace_time_offset : float = 0.0
	animation.track_insert_key(track_index, total_time, 0)
	var total_animation_length : float = 0.0
	for character : String in p_text:
		total_time += p_time_per_character
		total_visible_characters += 1
		if not p_time_whitespace and whitespace_regex.sub(character, "", true).is_empty():
			whitespace_time_offset += p_time_per_character
			continue
		total_animation_length = total_time - whitespace_time_offset
		animation.track_insert_key(track_index, total_animation_length, total_visible_characters)
	animation.set_length(total_animation_length)

	if p_instant_first_character:
		if animation.track_get_key_count(track_index) > 0:
			# Shift all the keys back in time according to the time it took per character
			for key_index : int in animation.track_get_key_count(track_index):
				var key_time : float = animation.track_get_key_time(track_index, key_index)
				animation.track_set_key_time(track_index, key_index, key_time - p_time_per_character)
			animation.set_length(total_animation_length - p_time_per_character)
	return animation
