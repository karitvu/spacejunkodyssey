extends StaticBody3D

@onready var interaktioitava: Area3D = %Interaktioitava
@onready var malli: MeshInstance3D = %Malli

func _ready() -> void:
	interaktioitava.interaktaa = _interaktio
	
func _interaktio():
	print("korjaa")
	Globaalit.VIAT -= 1
	queue_free()
