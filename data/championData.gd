# ChampionData.gd
extends Resource
class_name ChampionData

@export_group("Stats")
@export var hp: float 
@export var hp_incr: float
@export var mp: float
@export var mp_incr: float
@export var hp_regen: float 
@export var hp_regen_incr: float 
@export var mp_regen: float 
@export var mp_regen_incr: float
@export var ar: float
@export var ar_incr: float
@export var ad: float 
@export var ad_incr: float
@export var mr: float 
@export var mr_incr: float 
@export var crit_dmg: float 
@export var ms: float 
@export var attack_range: float

@export_group("Attack Speed")
@export var base_as: float 
@export var windup_percent: float 
@export var as_ratio: float 
@export var bonus_as_ratio: float
@export var missile_speed: float

@export_group("Unit Radius")
@export var gameplay_radius: float 
@export var select_radius: float 
@export var pathing_radius: float
@export var select_height: float
@export var acq_radius: float 
