extends CharacterBody3D

@export var NOPEUS = 10.0

var painovoima = 10
@onready var säde = %Spawnicast
var xform : Transform3D
@export var KÄÄNTÖ = 25.0

var katsomissuunta: Vector2

@onready var alus = %Alus
var painovoimaylös = Vector3.UP

@onready var spawniaika = %Spawniajastin
@onready var suunta_aika = %"Suunta-ajastin"
@onready var kohta: Node3D = %Kohta


var suunnat = [Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]
var käännökset = ["oikea", "vasen", "suoraan"]
var input_suunta = suunnat.pick_random()

var vika = preload("res://Peli/vika.tscn")
var räjähdys = preload("res://Peli/räjähdys.tscn")

# Poistetaan latauslagi lataamalla ja poistamalla
func _ready() -> void:
	var lagi = vika.instantiate()
	var piikki = räjähdys.instantiate()
	
	lagi.global_position = Vector3(1000,1000,1000)
	piikki.global_position = Vector3(1000,1000,1000)
	
	%Viat.add_child(lagi)
	%Viat.add_child(piikki)
	
	await get_tree().create_timer(2.0).timeout
	lagi.queue_free()

func _physics_process(delta: float) -> void:
	
	# Haetaan painovoiman suunta
	if säde.is_colliding():
		painovoimaylös = säde.get_collision_normal()
	
	# Käännetään lattian mukaisesti
	var eteen = global_transform.basis.z
	
	var tavoiteltu = global_transform.looking_at(global_position - eteen, painovoimaylös)
	global_transform.basis = global_transform.basis.slerp(tavoiteltu.basis, 0.1)
	
	up_direction = painovoimaylös
	
	velocity.y -= painovoimaylös.y * painovoima * delta
	
	# Minne ollaan menossa
	var suunta = (transform.basis * Vector3(input_suunta.x, 0, input_suunta.y)).normalized()
	
	# Liikutus
	if suunta != Vector3.ZERO:
		velocity.x = suunta.x * NOPEUS
		velocity.z = suunta.z * NOPEUS
	else:
		velocity.x = move_toward(velocity.x, 0, NOPEUS)
		velocity.z = move_toward(velocity.z, 0, NOPEUS)
	
	# Liikkeen päivitys
	move_and_slide()
	
	# Lattiassa kiinni pitäminen ja oikea asento
	if not is_on_floor():
		apply_floor_snap()
	
	var n = säde.get_collision_normal()
	var suoristus = align_with_y(global_transform, n)
	global_transform = global_transform.interpolate_with(suoristus, 12 * delta)
	
	return

# Asennon korjauksen avustin
func align_with_y(suoristus, uusi_y):
	suoristus.basis.y = uusi_y
	suoristus.basis.x = -suoristus.basis.z.cross(uusi_y)
	suoristus.basis = suoristus.basis.orthonormalized()
	return suoristus

# Kameran ja hahmon kääntäminen
func _käännä_suuntaa():
	var minne = käännökset.pick_random()
	if minne == "oikea":
		%Spawneri.rotate_object_local(Vector3(0,1,0), deg_to_rad(-KÄÄNTÖ))
	if minne == "vasen":
		%Spawneri.rotate_object_local(Vector3(0,1,0), deg_to_rad(KÄÄNTÖ))

# Muutetaan suuntaa ajastimella
func _on_suuntaajastin_timeout() -> void:
	input_suunta = suunnat.pick_random()
	_käännä_suuntaa()

# Spawnataan vika
func _on_spawniajastin_timeout() -> void:
	print("VIKAPAIKKA")
	print(global_basis)
	var uusivika = vika.instantiate()
	var pum = räjähdys.instantiate()
	var paikka = kohta.global_position # - painovoimaylös * Vector3.UP * 5
	var kulma = kohta.global_rotation
	var miten = säde.get_collision_normal()
	uusivika.rotate_object_local(miten, deg_to_rad(kulma.z))
	uusivika.rotate_object_local(miten, deg_to_rad(kulma.x))
	pum.rotation_degrees = painovoimaylös
	uusivika.global_position = paikka
	pum.global_position = paikka
	
	%Viat.add_child(uusivika)
	%Viat.add_child(pum)
	Globaalit.VIAT += 1
	
