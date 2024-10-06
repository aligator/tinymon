class_name Fight_stats extends Node

var fightId: String
var hpAttacker: int
var hpDefender: int

# Constructor
func _init(
	fightId: String,
	hpAttacker: int,
	hpDefender: int, 
):
	self.fightId = fightId
	self.hpAttacker = hpAttacker
	self.hpDefender = hpDefender
