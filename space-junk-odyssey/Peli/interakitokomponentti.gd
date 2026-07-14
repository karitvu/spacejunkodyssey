extends Node3D

@onready var interaktioteksti: Label = %Interaktioteksti
@onready var mittari: ProgressBar = %Mittari
var interaktiot := []
var voi_interaktaa := true
@onready var korjausaika: Timer = %Korjausaika
@onready var elkkupalkki: TextureProgressBar = %Elkkupalkki

func _ready() -> void:
	%Elkkupalkki.max_value = Globaalit.MAX_VIAT
	%Elkkupalkki.value = Globaalit.VIAT
	%Hyppypalkki.max_value = Globaalit.VOITTOAIKA
	%Hyppypalkki.value = Globaalit.HYPPYAIKA
	korjausaika.wait_time = Globaalit.KORJAUSAIKA

func _input(event):
	if event.is_action_pressed("korjaa") and voi_interaktaa:
		if interaktiot:
			%Korjausaika.start()
	if event.is_action_released("korjaa") and voi_interaktaa:
		if interaktiot:
			%Korjausaika.stop()

func _process(_delta: float) -> void:
	if interaktiot and voi_interaktaa:
		interaktiot.sort_custom(_järjestä_lähimmät)
		if interaktiot[0].interaktioitava:
			interaktioteksti.text = interaktiot[0].nimi
			interaktioteksti.show()
			mittari.show()
	else:
		interaktioteksti.hide()
		mittari.hide()
	if %Korjausaika.time_left > 0:
		%Mittari.value = Globaalit.KORJAUSAIKA - %Korjausaika.time_left
	%Elkkupalkki.value = Globaalit.MAX_VIAT - Globaalit.VIAT
	%Hyppypalkki.value = Globaalit.HYPPYAIKA

func _järjestä_lähimmät(alue1, alue2):
	var alue1_etäisyys = global_position.distance_to(alue1.global_position)
	var alue2_etäisyys = global_position.distance_to(alue2.global_position)
	return alue1_etäisyys < alue2_etäisyys

func _on_interaktioetäisyys_area_entered(area: Area3D) -> void:
	interaktiot.push_back(area)
	voi_interaktaa = true
	%Korjausaika.stop()
	%Mittari.value = 0

func _on_interaktioetäisyys_area_exited(area: Area3D) -> void:
	interaktiot.erase(area)
	voi_interaktaa = false
	%Korjausaika.stop()
	%Mittari.value = 0


func _on_korjausaika_timeout() -> void:
	%Korjausaika.stop()
	if interaktiot and voi_interaktaa:
		await interaktiot[0].interaktaa.call()
		voi_interaktaa = false
