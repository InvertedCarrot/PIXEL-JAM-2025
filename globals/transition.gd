extends CanvasLayer


func _ready() -> void:
	print("children = ", get_tree())
	$ColorRect.modulate = Color(1,1,1,0)

func change_scene(target_scene: String):
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file.call_deferred(target_scene)
	$AnimationPlayer.play_backwards("fade_out")
	await $AnimationPlayer.animation_finished
