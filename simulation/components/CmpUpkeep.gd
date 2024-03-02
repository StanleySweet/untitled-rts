extends ICmpUpkeep
class_name CmpUpkeep
@export var Interval : int
@export var Rates : PyrogenesisResources

var _rates :PyrogenesisResources
var _timer : Timer = null

func _ready() -> void:
	self.check_timer()

func get_interval() -> int:
	return self.Interval

func get_rates() -> PyrogenesisResources:
	return self._rates
	

func pay():
	var cmpPlayer : ICmpPlayer = PlayerHelper.query_owner_interface(self.entity)
	if cmpPlayer == null:
		return;
#
	if !cmpPlayer.TrySubtractResources(self.rates):
		self.handle_insufficient_upkeep();
	else:
		self.handle_sufficient_upkeep();

## E.g. take a hitpoint, reduce CP.
func handle_insufficient_upkeep() -> void:
	if self.unpayed:
		return;

	var cmpIdentity : ICmpIdentity = PyrogenesisEngine.query_interface(self.entity, ICmpIdentity.IID);
	if cmpIdentity:
		cmpIdentity.set_controllable(false);

	self.unpayed = true;
	
## Reset to the previous stage.
func handle_sufficient_upkeep() -> void:
	if !self.unpayed:
		return;

	var cmpIdentity = PyrogenesisEngine.query_interface(self.entity, ICmpIdentity.IID);
	if cmpIdentity:
		cmpIdentity.SetControllable(true);
	self.unpayed = false;

func compute_rates() -> bool:
	return true;
	#self._rates = Resources.new()
	#var hasUpkeep : bool = false;
	#for resource in self.Rates.keys():
		#print(self.Rates.keys())
		#var rate = ValueModification.apply_to_entity("Upkeep/Rates/" + resource, self.Rates[resource], self.entity);
		#if (rate > 0):
			#self._rates[resource] = rate;
			#hasUpkeep = true;

	#return hasUpkeep

func check_timer():
	if not compute_rates():
		if self._timer:
			self._timer.connect("timeout", self.pay) 
