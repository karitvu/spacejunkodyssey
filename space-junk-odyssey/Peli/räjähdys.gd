extends Node3D

@onready var roina: GPUParticles3D = $Roina
@onready var savu: GPUParticles3D = $Savu
@onready var tuli: GPUParticles3D = $Tuli
@onready var ääni: AudioStreamPlayer3D = $Ääni

func _ready() -> void:
	roina.emitting = true
	savu.emitting = true
	tuli.emitting = true
	ääni.play()
	await get_tree().create_timer(2.0).timeout
	queue_free()
