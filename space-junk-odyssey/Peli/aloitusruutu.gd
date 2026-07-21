extends Control

var peli = preload("res://Peli/maailma.tscn")
@onready var holoraketti: Node3D = %Holoraketti
@onready var nappiääni: AudioStreamPlayer = %Nappiääni


func _on_pelaa_pressed() -> void:
	nappiääni.play()
	get_tree().change_scene_to_file("res://Peli/maailma.tscn")

func _process(delta: float) -> void:
	holoraketti.rotate_y(deg_to_rad(1.0))
