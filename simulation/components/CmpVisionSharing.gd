# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpVisionSharing
class_name CmpVisionSharing

@export var Bribable : bool

func check_vision_sharings():
	pass


func add_spy(player : int, timeLength : int) -> int:
	if !self.Bribable:
		return PyrogenesisEngine.INVALID_ENTITY

	var cmpOwnership = PyrogenesisEngine.QueryInterface(self.entity, ICmpOwnership.IID_Ownership);
	if !cmpOwnership || cmpOwnership.get_owner() == player || player <= 0:
		return PyrogenesisEngine.INVALID_ENTITY

	var cmpTechnologyManager = PlayerHelper.QueryPlayerIDInterface(player, ICmpTechnologyManager.IID_TechnologyManager);
	if !cmpTechnologyManager || !cmpTechnologyManager.CanProduce("special/spy"):
		return PyrogenesisEngine.INVALID_ENTITY

	var template = PyrogenesisEngine.QueryInterface(SYSTEM_ENTITY, ICmpTemplateManager.IID_TemplateManager).GetTemplate("special/spy");
	if (!IncurBribeCost(template, player, cmpOwnership.GetOwner(), false))
		return 0;

	return self.spyId

func remove_spy(data):
	self.spies.delete(data.id)
	self.check_vision_sharings()

func share_vision_with(player : int):
	if self.activated:
		return self.shared.has(player)

	var cmpOwnership = PyrogenesisEngine.QueryInterface(self.entity, ICmpOwnership.IID_Ownership);
	return cmpOwnership != null && cmpOwnership.get_owner() == player
