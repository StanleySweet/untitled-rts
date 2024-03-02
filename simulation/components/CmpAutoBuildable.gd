# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpAutoBuildable
class_name CmpAutoBuildable

@export var template : CmpAutoBuildableSchema

var timer : Variant = null
var rate : Variant = null

func _ready():
	self.update_rate()
	
func get_rate():
	return self.rate

func update_rate():
	self.rate = ValueModification.apply_to_entity("AutoBuildable/Rate", self.template.Rate, self.entity);
	if self.rate:
		self.start_timer()

func start_timer():
	if self.timer || not self.rate:
		return;
	
	var cmpFoundation : ICmpFoundation = PyrogenesisEngine.query_interface(self.entity, ICmpFoundation.IID);
	if not cmpFoundation:
		return;

	cmpFoundation.add_builder(self.entity);
	var cmpTimer = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpTimer.IID);
	self.timer = cmpTimer.set_interval(self.entity, ICmpAutoBuildable.IID, "AutoBuild", 0, 1000, null);

func cancel_timer():
	if not self.timer:
		return;
	
	var cmpFoundation : ICmpFoundation = PyrogenesisEngine.query_interface(self.entity, ICmpFoundation.IID);
	if not cmpFoundation:
		return;

	cmpFoundation.remove_builder(self.entity);
	var cmpTimer = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpTimer.IID);
	cmpTimer.cancel_timer(self.timer);
	self.timer = null;

func autobuild():
	if not self.rate:
		self.cancel_timer();
		return;

	var cmpFoundation = PyrogenesisEngine.query_interface(self.entity, ICmpFoundation.IID);
	if not cmpFoundation:
		self.cancel_timer();
		return;

	cmpFoundation.build(self.entity, self.rate)

func on_value_modification(msg : Dictionary):
	if msg.component != "AutoBuildable":
		return;

	self.update_rate();

func on_ownership_changed(msg):
	if msg.to == PlayerHelper.INVALID_PLAYER:
		return;

	self.update_rate();
