extends Node3D

@onready var ground = $Ground
@onready var backdrop = $Backdrop
@onready var overlay = $Camera3D/PixelArtOverlay
@onready var camera = $Camera3D
@onready var pixel_slider = $UI/Panel/VBoxContainer/PixelationSlider
@onready var crush_slider = $UI/Panel/VBoxContainer/CrushSlider
@onready var pixel_label = $UI/Panel/VBoxContainer/PixelLabel
@onready var crush_label = $UI/Panel/VBoxContainer/CrushLabel

var speed = 10.0
var rotation_speed = 0.5
var material: ShaderMaterial
var angle = 0.0
var base_distance = 5.0

func _ready():
	material = overlay.get_surface_override_material(0)
	pixel_slider.value = material.get_shader_parameter("pixelation_level")
	crush_slider.value = material.get_shader_parameter("crush")
	update_labels()

func _process(delta):
	# Move ground and backdrop to simulate driving
	ground.position.z += speed * delta
	if ground.position.z > 50:
		ground.position.z -= 100
	
	backdrop.position.z += (speed * 0.1) * delta # Parallax
	if backdrop.position.z > 100:
		backdrop.position.z -= 200
		
	# Camera Orbit logic
	angle += rotation_speed * delta
	var x = sin(angle) * base_distance
	var z = cos(angle) * base_distance
	camera.position = Vector3(x, 1.5, z)
	camera.look_at(Vector3(0, 0.5, 0))

func _on_pixelation_slider_value_changed(value):
	material.set_shader_parameter("pixelation_level", int(value))
	update_labels()

func _on_crush_slider_value_changed(value):
	material.set_shader_parameter("crush", value)
	update_labels()

func update_labels():
	pixel_label.text = "Pixelation: " + str(material.get_shader_parameter("pixelation_level"))
	crush_label.text = "Color Crush: " + str(snapped(material.get_shader_parameter("crush"), 0.01))
