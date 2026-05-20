extends Node2D


@export var base_light_energy := 0.3
@export var near_light_energy := 0.8
@export_multiline var guidance: String

@onready var popup: RichTextLabel = $HintUI/RichTextLabel
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var timer = $Timer
@onready var light := $PointLight2D
@onready var particles := $GPUParticles2D

var player_near := false
var popup_visible := false

func _ready():
	light.energy = base_light_energy
	popup.pivot_offset = popup.size / 2
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _process(delta):
	# lerp để chuyển mượt
	var target := near_light_energy if player_near else base_light_energy
	light.energy = lerp(light.energy, target, delta * 4)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_near = true
		$Sprite2D.scale=lerp($Sprite2D.scale,Vector2(1,1), 0.05)
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_near = false
		$Sprite2D.scale=lerp($Sprite2D.scale,Vector2(0.3,0.3), 0.05)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
	
		timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not popup_visible:
		popup_visible = true
		AudioManager.play_sound(AudioIds.HINT_POPUP)
		popup.text = guidance
		anim_player.play("popup_show")


func _on_timer_timeout() -> void:
	popup_visible = false
	anim_player.play("popup_hide")
