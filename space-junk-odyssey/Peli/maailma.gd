extends Node3D

@onready var loppuruutu: CanvasLayer = %Loppuruutu
@onready var kartankääntö: Node3D = %Kartankääntö
@onready var karttakamera: Camera3D = %Karttakamera
@onready var kameraankkuri: Node3D = %Kameraankkuri
@onready var karttavalo: DirectionalLight3D = %Karttavalo


func _process(_delta: float) -> void:
	if Globaalit.HYPPYAIKA >= Globaalit.VOITTOAIKA:
		lopetus("Mission passed! Respect++")
	if Globaalit.VIAT >= Globaalit.MAX_VIAT:
		lopetus("Mission failed! We'll get them next time.")
	
	if Input.is_action_pressed("karttaoikea"):
		kartankääntö.rotate_z(deg_to_rad(-1))
	if Input.is_action_pressed("karttavasen"):
		kartankääntö.rotate_z(deg_to_rad(1))
	if Input.is_action_pressed("karttaylös"):
		kartankääntö.rotate_x(deg_to_rad(-1))
	if Input.is_action_pressed("karttaalas"):
		kartankääntö.rotate_x(deg_to_rad(1))
	
	karttakamera.global_transform = kameraankkuri.global_transform
	karttavalo.rotation = kartankääntö.rotation + Vector3(-90, 0, 0)

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
