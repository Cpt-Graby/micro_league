extends CanvasLayer


@onready var canvas_layer: CanvasLayer = $"."
@onready var score: Label = $score
@onready var score_label = $Panel/ScoreLabel 

func set_score(final_score: float):
	score_label.text = str(final_score)
	pass

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass
