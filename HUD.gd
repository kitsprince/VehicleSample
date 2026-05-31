extends CanvasLayer

@onready var crosshair = $Crosshair
@onready var game_over = $GameOver

var pixel_art_material: ShaderMaterial = preload("res://pixel_art_material.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("player_speed", set_speed)
	Events.connect("player_health", set_health)
	
	crosshair.visible = true
	game_over.visible = false
	
	# Connect slider signals
	$ShaderControls/VBoxContainer/PixelationSlider.value_changed.connect(_on_pixelation_slider_value_changed)
	$ShaderControls/VBoxContainer/CrushSlider.value_changed.connect(_on_crush_slider_value_changed)
	
	# Set initial values
	$ShaderControls/VBoxContainer/PixelationSlider.value = pixel_art_material.get_shader_parameter("pixelation_level")
	$ShaderControls/VBoxContainer/CrushSlider.value = pixel_art_material.get_shader_parameter("crush")
	update_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pixelation_slider_value_changed(value):
	pixel_art_material.set_shader_parameter("pixelation_level", int(value))
	update_labels()

func _on_crush_slider_value_changed(value):
	pixel_art_material.set_shader_parameter("crush", value)
	update_labels()

func update_labels():
	$ShaderControls/VBoxContainer/PixelLabel.text = "Pixelation: " + str(pixel_art_material.get_shader_parameter("pixelation_level"))
	$ShaderControls/VBoxContainer/CrushLabel.text = "Color Crush: " + str(snapped(pixel_art_material.get_shader_parameter("crush"), 0.01))

func set_speed(kmh):
	$Info.text=str(round(kmh)).pad_zeros(3) + "km/h"
	$FPS.set_text("FPS %d" % Engine.get_frames_per_second())
	
func set_health(health):
	$Health.set_text("HP: " + str(health).pad_zeros(3))
	
	if health <= 0:
		crosshair.visible = false
		game_over.visible = true
