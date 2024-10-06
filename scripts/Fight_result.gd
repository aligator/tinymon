class_name Fight_result extends Node

var fightId: String
var hpAttacker: int
var hpDefender: int

var hpAttacker2: int
var hpDefender2: int

var attacker_attack_type: Global.FIGHT_TYPE
var defender_attack_type: Global.FIGHT_TYPE
var defender_did_attack: bool

# Constructor
func _init(
	fightId: String,
	hpAttacker: int,
	hpDefender: int, 
	
	hpAttacker2: int,
	hpDefender2: int, 
	
	attacker_attack_type: Global.FIGHT_TYPE,
	defender_attack_type: Global.FIGHT_TYPE,
	defender_did_attack: bool,
):
	self.fightId = fightId
	self.hpAttacker = hpAttacker
	self.hpDefender = hpDefender
	
	self.hpAttacker2 = hpAttacker2
	self.hpDefender2 = hpDefender2
	
	self.attacker_attack_type = attacker_attack_type
	self.defender_attack_type = defender_attack_type
	self.defender_did_attack = defender_did_attack
