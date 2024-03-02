extends ICmpAttackDetection
class_name CmpAttackDetection
@export var template : CmpAttackDetectionSchema

var suppressionTime : int
var suppressionTransferRangeSquared : float
var suppressionRangeSquared : float
var suppressedList : Array

func _ready():
	self.suppressionTime = self.template.SuppressionTime
	# Use squared distance to avoid sqrts
	self.suppressionTransferRangeSquared = self.template.SuppressionTransferRange * self.template.SuppressionTransferRange
	self.suppressionRangeSquared = self.template.SuppressionRange * self.template.SuppressionRange
	self.suppressedList = []

func activate_timer():
	PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpTimer.IID).SetTimeout(self.entity, ICmpAttackDetection.IID, "HandleTimeout", self.suppressionTime)

func add_suppression(event):
	self.suppressedList.append(event)
	self.activate_timer()

func update_suppression_event(index, event):
	self.suppressedList[index] = event
	self.activate_timer()

# Message handlers

func on_global_attacked(msg):
	var cmpPlayer : ICmpPlayer = PyrogenesisEngine.query_interface(self.entity, ICmpPlayer.IID)
	var cmpOwnership : ICmpOwnership = PyrogenesisEngine.query_interface(msg.target, ICmpOwnership.IID)
	if (cmpOwnership.get_owner_id() != cmpPlayer.get_player_id()): return
	self.minimap_ping.emit(msg.target)
	self.attack_alert(msg.target, msg.attacker, msg.type, msg.attackerOwner)


# External interface

func attack_alert(target, attacker, type, attackerOwner):
	var playerID = PyrogenesisEngine.query_interface(self.entity, ICmpPlayer.IID).GetPlayerID()

	# Don't register attacks dealt against other players
	if (PyrogenesisEngine.query_interface(target, ICmpOwnership.IID).GetOwner() != playerID): return
	var cmpAttackerOwnership : ICmpOwnership = PyrogenesisEngine.query_interface(attacker, ICmpOwnership.IID)
	var atkOwner = cmpAttackerOwnership.GetOwner() if cmpAttackerOwnership && cmpAttackerOwnership.get_owner_id() != PlayerHelper.INVALID_PLAYER else attackerOwner
	# Don't register attacks dealt by myself
	if (atkOwner == playerID): return

	# Since livestock can be attacked/gathered by other players
	# and generally are not so valuable as other units/buildings,
	# we have a lower priority notification for it, which can be
	# overriden by a regular one.
	var cmpTargetIdentity = PyrogenesisEngine.query_interface(target, ICmpIdentity.IID)
	var targetIsDomesticAnimal = cmpTargetIdentity && cmpTargetIdentity.HasClass("Animal") && cmpTargetIdentity.HasClass("Domestic")
	var cmpPosition = PyrogenesisEngine.query_interface(target, ICmpPosition.IID)
	if (!cmpPosition || !cmpPosition.IsInWorld()): return
	var event = {
	"target": target,
	"position": cmpPosition.GetPosition(),
	"time": PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpTimer.IID).GetTime(),
	"targetIsDomesticAnimal": targetIsDomesticAnimal
	}

	# If we already have a low priority livestock event in suppressed list,
	# and now a more important target is attacked, we want to upgrade the
	# suppressed event and send the new notification
	var isPriorityIncreased = false
	for i in range(self.suppressedList.size()):
		var element = self.suppressedList[i]

		# If the new attack is within suppression distance of this element,
		# then check if the element should be updated and return
		var dist = event.position.horizDistanceToSquared(element.position)
		if (dist >= self.suppressionRangeSquared): continue
		isPriorityIncreased = element.targetIsDomesticAnimal && !targetIsDomesticAnimal
		var isPriorityDescreased = !element.targetIsDomesticAnimal && targetIsDomesticAnimal
		if (isPriorityIncreased || !isPriorityDescreased && dist < self.suppressionTransferRangeSquared): self.update_suppression_event(i, event)

		# If priority has increased, exit the loop to send the upgraded notification below
		if (isPriorityIncreased): break
		return

	# If priority has increased for an existing event, then we already have it
	# in the suppression list
	if (!isPriorityIncreased): self.add_suppression(event)
	self.attack_detected.emit(self.entity, {
	"player": playerID,
	"event": event
	})
	PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpGuiInterface.IID).push_notification({
	"type": "attack",
	"target": target,
	"players": [playerID],
	"attacker": atkOwner,
	"position": event.position,
	"targetIsDomesticAnimal": targetIsDomesticAnimal
	})
	var soundGroup = "attacked"
	if (type == "capture"): soundGroup += "_capture"
	if (attackerOwner == 0): soundGroup += "_gaia"
	ICmpSoundManager.play_sound(soundGroup, target)


func get_suppression_time():
	return self.suppressionTime

func handle_timeout():
	var cmpTimer : ICmpTimer = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpTimer.IID)
	var now = cmpTimer.get_time()
	for i in range(self.suppressedList.size()):
		var event = self.suppressedList[i]
		# Check if this event has timed out
		if (now - event.time >= self.suppressionTime):
			self.suppressedList.remove_at(i)
			return

func get_incoming_attacks():
	return self.suppressedList

#PyrogenesisEngine.RegisterComponentType(ICmpAttackDetection.IID, "AttackDetection", AttackDetection)
