extends RayCast2D

# Speed at which the laser extends when first fired, in pixels per seconds.
@export var cast_speed := 7000.0
# Maximum length of the laser in pixels.
@export var max_length := 1400.0
# Base duration of the tween animation in seconds.
@export var growth_time := 0.1

# If `true`, the laser is firing.
# It plays appearing and disappearing animations when it's not animating.
# See `appear()` and `disappear()` for more information.
var is_casting := false: set = set_is_casting

var tween : Tween


func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO


func _physics_process(delta: float) -> void:
	target_position = (target_position + Vector2.RIGHT * cast_speed * delta).limit_length(max_length)
	cast_beam()


func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		target_position = Vector2.ZERO
		$Line2D.points[1] = target_position
		appear()
	else:
		# Reset the laser endpoint
		$Line2D.points[1] = Vector2.ZERO
		
		$CollisionParticles.emitting = false
		disappear()

	set_physics_process(is_casting)
	$BeamParticles.emitting = is_casting
	$CastingParticles.emitting = is_casting
	

# Controls the emission of particles and extends the Line2D to `cast_to` or the ray's 
# collision point, whichever is closest.
func cast_beam() -> void:
	var cast_point := target_position

	force_raycast_update()
	$CollisionParticles.emitting = is_colliding()

	if is_colliding():
		cast_point = to_local(get_collision_point())
		$CollisionParticles.global_rotation = get_collision_normal().angle()
		$CollisionParticles.position = cast_point

	$Line2D.points[1] = cast_point
	$BeamParticles.position = cast_point * 0.5
	$BeamParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5


func appear() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(
		$Line2D, "width", $Line2D.line_width, growth_time * 2
	).from(0)


func disappear() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, growth_time).from_current()
