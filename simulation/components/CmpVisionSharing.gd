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

	var cmpOwnership = PyrogenesisEngine.query_interface(self.entity, ICmpOwnership.IID);
	if !cmpOwnership || cmpOwnership.get_owner() == player || player <= 0:
		return PyrogenesisEngine.INVALID_ENTITY

	var cmpTechnologyManager = PlayerHelper.query_player_id_interface(player, ICmpTechnologyManager.IID);
	if !cmpTechnologyManager || !cmpTechnologyManager.CanProduce("special/spy"):
		return PyrogenesisEngine.INVALID_ENTITY

	var template = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpTemplateManager.IID);
	if (!CommandsHelper.incur_bribe_cost(template, player, cmpOwnership.GetOwner(), false)):
		return 0;

	return self.spyId

func remove_spy(data):
	self.spies.delete(data.id)
	self.check_vision_sharings()

func share_vision_with(player : int):
	if self.activated:
		return self.shared.has(player)

	var cmpOwnership = PyrogenesisEngine.query_interface(self.entity, ICmpOwnership.IID);
	return cmpOwnership != null && cmpOwnership.get_owner() == player
