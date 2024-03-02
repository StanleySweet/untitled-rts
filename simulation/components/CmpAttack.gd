extends ICmpAttack
class_name CmpAttack
static var AttackTypes : PackedStringArray = [
	"Melee",
	"Ranged",
	"Capture"
]

var attackType : Dictionary
@export var template : CmpAttackSchema
# Called when the node enters the scene tree for the first time.
func _ready():
	for at : AttackType in self.template.Attacks:
		if at.Type == AttackType.EAttackType.Ranged:
			self.attackType["Ranged"] = at
		elif at.Type == AttackType.EAttackType.Melee:
			self.attackType["Melee"] = at
		elif at.Type == AttackType.EAttackType.Capture:
			self.attackType["Capture"] = at

func get_full_attack_range() -> Dictionary:
	return {
		"max" : 0,
		"min" : 0
	}
	
func get_range(type : String) -> Dictionary:
	if not type:
		return self.get_full_attack_range()
		
	var maxRange = self.attackType[type].MaxRange;
	maxRange = ValueModification.apply_to_entity("Attack/" + type + "/MaxRange", maxRange, self.entity);

	var minRange = self.attackType[type].MinRange;
	minRange = ValueModification.apply_to_entity("Attack/" + type + "/MinRange", minRange, self.entity);

	return { "max": maxRange, "min": minRange };

func get_attack_types(wantedTypes = null) -> PackedStringArray:
	var types : PackedStringArray = []
	for attack in AttackTypes:
		if self.attackType.has(attack):
			types.push_back(attack)
	
	if not wantedTypes:
		return types;

	var wantedTypesReal: PackedStringArray = []
	for wtype in wantedTypes:
		if not wtype.contains("!"):
			types.push_back(wtype)

	var result: PackedStringArray = []
	for type in types:
		if wantedTypes.has("!" + type) and (not wantedTypesReal or !wantedTypesReal.size() > 0 or wantedTypesReal.has(type)):
			types.push_back(type)

	return result

func get_repeat_time(type):
	var repeatTime : int = 1000;

	if self.attackType[type] && self.attackType[type].RepeatTime:
		repeatTime = self.attackType[type].RepeatTime;

	return ValueModification.apply_to_entity("Attack/" + type + "/RepeatTime", repeatTime, self.entity);
	

func get_attack_name(type : String) -> Dictionary :
	return {
		"name": self.attackType[type].AttackName._string || self.attackType[type].AttackName,
		"context": self.attackType[type].AttackName["@context"]
	};

func get_attack_y_origin(type) -> float:
	if not self.attackType[type].Origin:
		return 0;

	return ValueModification.apply_to_entity("Attack/" + type + "/Origin/Y", self.attackType[type].Origin.Y, self.entity)

func is_target_in_range(target : int, type) -> bool :
	var _range = self.get_range(type)
	return PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpObstructionManager.IID).IsInTargetParabolicRange(
		self.entity,
		target,
		_range.min,
		_range.max,
		self.get_attack_y_origin(type),
		false)

func on_value_modification(msg: Dictionary) -> void:
	if msg["component"] != "Attack":
		return
	
	var cmpUnitAI : ICmpUnitAI = PyrogenesisEngine.query_interface(self.entity, ICmpUnitAI.IID)
	if not cmpUnitAI:
		return
		
	var attackTypes: PackedStringArray = self.get_attack_types()
	for type in attackTypes:
		if msg["valueNames"].find("Attack/" + type + "/MaxRange") != -1:
			cmpUnitAI.update_range_queries()

func get_range_overlays(type: String = "Ranged") -> Array:
	if (!self.attackType.has(type) || !self.attackType[type].RangeOverlay):
		return [];

	var _range : Dictionary = self.get_range(type);
	var rangeOverlays: Array[Dictionary] = [];
	for i in _range.keys():
		if (i == "min" || i == "max") && _range[i]:
			rangeOverlays.append({
				"radius": _range[i],
				"texture": self.attackType[type].RangeOverlay.LineTexture,
				"textureMask": self.attackType[type].RangeOverlay.LineTextureMask,
				"thickness": +self.template[type].RangeOverlay.LineThickness,
			});
	return rangeOverlays;
