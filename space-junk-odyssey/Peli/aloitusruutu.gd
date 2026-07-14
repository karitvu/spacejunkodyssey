extends Control

var peli = preload("res://Peli/maailma.tscn")

func _on_pelaa_pressed() -> void:
	get_tree().change_scene_to_file("res://Peli/maailma.tscn")
