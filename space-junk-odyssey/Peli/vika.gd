extends StaticBody3D

@onready var interaktioitava: Area3D = %Interaktioitava
@onready var malli = %Malli
@onready var ääniaika: Timer = %Ääniaika
@onready var sähköääni: AudioStreamPlayer3D = %Sähköääni

func _ready() -> void:
	interaktioitava.interaktaa = _interaktio
	ääniaika.start()
	
func _interaktio():
	print("korjaa")
	Globaalit.VIAT -= 1
	ääniaika.stop()
	queue_free()

func _on_ääniaika_timeout() -> void:
	sähköääni.play()
