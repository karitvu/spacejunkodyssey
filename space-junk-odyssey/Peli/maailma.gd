extends Node3D

@onready var loppuruutu: CanvasLayer = %Loppuruutu



func _process(_delta: float) -> void:
	if Globaalit.HYPPYAIKA >= Globaalit.VOITTOAIKA:
		lopetus("Mission passed! Respect++")
	if Globaalit.VIAT >= Globaalit.MAX_VIAT:
		lopetus("Mission failed! We'll get them next time.")



func _on_voittoaika_timeout() -> void:
	Globaalit.HYPPYAIKA += 0.1


func lopetus(tulos: String):
	get_tree().paused = true
	%Teksti.text = tulos
	loppuruutu.show()

func _on_nappi_pressed() -> void:
	get_tree().paused = false
	Globaalit.HYPPYAIKA = 0
	Globaalit.VIAT = 0
	get_tree().change_scene_to_file("res://Peli/aloitusruutu.tscn")
