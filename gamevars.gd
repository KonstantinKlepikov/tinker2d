extends Node


var current_map: Node2D # current map instance
var line_points: PackedVector2Array # hero line points
var line: Line2D # current path line
var in_node := false # is mouse inside node
var is_draging: bool = false # is dragging vieport
var in_map: bool = false # is mouse on a map
var hero_pos: Vector2 # global position of hero
var is_hero_on_start_or_end: bool # check can be act something with hero
var is_hero_empty: bool = false # check is not hero energy empty
var current_mouse_in_enemy: Area2D = null # current enemy where mouse in
var aiming_queue: Dictionary = {} # current aiming queue,
# where key is a names of enemy and weapon, value is a enemy node


# game constants
const HERO_START_ENERGY: float = 6000.0
const HERO_SPEED: float = 0.015

const TERRAIN_BASE_COEF: float = 1.0
const TERRAIN_SPEED_COEF_05: float = 0.5

const HERO_SPEED_REDUCER: float = 2.0 # energy consume = reducer - speed coef
const MIN_HERO_SPEED: float = 0.01

const BUST_COEF: float = 2.0
const BUST_ENERGY_CONSUME: float = 3.0
const BUST_DURATION: float = 2.0
const BUST_TIMEOUT: float = 5.0

const ATTACK_RADIUS_COLOR := Color.RED
const AIMING_RADIUS_COLOR := Color.YELLOW

const HOMING_ENEMY_SPEED: float = 60.0
const HOMING_ENEMY_STEER_FORCE: float = 30.0
const HOMING_ENEMY_ACTIVATION_RADIUS: float = 400.0
const HOMING_ENEMY_DAMAGE: float = 400.0
const HOMING_ENEMY_HEALTH: int = 200
