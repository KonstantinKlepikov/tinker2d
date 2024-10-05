extends Node


var current_map: Node2D # current map instance
var line: Line2D # current path line
var in_node := false # is mouse inside node
var in_enemy := false # is mouse inside enemy node
var is_draging: bool = false # is dragging vieport
var in_map: bool = false # is mouse on a map
var hero_pos: Vector2 # global position of hero
var is_hero_on_start_or_end: bool # check can be act something with hero
var is_hero_empty: bool = false # check is not hero energy empty


# game constants
const HERO_START_ENERGY: int = 1500
const HERO_SPEED: float = 0.04

const TERRAIN_BASE_COEF: float = 1.0
const TERRAIN_SPEED_COEF_05: float = 0.5

const HERO_SPEED_REDUCER: float = 2.0 # energy consume = reducer - speed coef
const MIN_HERO_SPEED: float = 0.01

const BUST_COEF: float = 2.0
const BUST_ENERGY_REDUCE: float = 10.0
const BUST_DURATION: float = 2.0
const BUST_TIMEOUT: float = 5.0

const ATTACK_RADIUS_COLOR := Color.RED
const AIMING_RADIUS_COLOR := Color.YELLOW
