extends RayCast2D

# Speed at which the laser extends when first fired, in pixels per seconds.
@export var cast_speed := 7000.0
# Maximum length of the laser in pixels.
@export var max_length := 1400.0
# Base duration of the tween animation in seconds.
@export var growth_time := 0.1

var is_casting := false: set = set_is_casting
var tween : Tween


func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO


func _physics_process(delta: float) -> void:
	target_position = (
		target_position + Vector2.RIGHT * cast_speed * delta
	).limit_length(max_length)
	cast_beam()


func set_is_casting(cast: bool) -> void:
	# setter to beam casting
	# If `true`, the laser is firing.
	# It plays appearing and disappearing animations when it's not animating.
	# See `appear()` and `disappear()` for more information.
	is_casting = cast
	
	if is_casting:
		target_position = Vector2.ZERO
		$Line2D.points[1] = target_position
		appear()
	else:
		# Reset the laser endpoint
		$Line2D.points[1] = Vector2.ZERO
		disappear()

	set_physics_process(is_casting)


func cast_beam() -> void:
	# Extends the Line2D to `cast_to` or the ray's collision point, 
	# whichever # is closest.
	var cast_point := target_position

	force_raycast_update()

	if is_colliding():
		cast_point = to_local(get_collision_point())

	$Line2D.points[1] = cast_point


func appear() -> void:
	# apear beam
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(
		$Line2D, "width", $Line2D.width, growth_time * 2
	).from(0)


func disappear() -> void:
	# disapear beam
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, growth_time).from_current()
