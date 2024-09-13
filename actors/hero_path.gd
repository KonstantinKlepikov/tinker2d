extends Path2D

var speed := 0.04
var speed_coef: float
var run := false # run or wait
var place := true # init first placement of hero


func _process(delta: float) -> void:
	if place:
		$PathFollow2D.progress_ratio += 0.0
		place = false
	if run:
		$PathFollow2D.progress_ratio += delta * speed * speed_coef
