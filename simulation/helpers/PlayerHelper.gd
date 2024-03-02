# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Node
class_name PlayerHelper

static var INVALID_PLAYER: int = -1

static func query_player_id_interface(id:int, iid:int = ICmpPlayer.IID):
	var cmpPlayerManager = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpPlayerManager.IID);

	var playerEnt = cmpPlayerManager.GetPlayerByID(id);
	if !playerEnt:
		return null;

	return PyrogenesisEngine.query_interface(playerEnt, iid);


static func query_owner_interface(ent: int, iid: int = ICmpPlayer.IID):
	var cmpOwnership = PyrogenesisEngine.query_interface(ent, ICmpOwnership.IID);
	if (!cmpOwnership):
		return null;

	var ownerId = cmpOwnership.get_owner_id();
	if (ownerId == PlayerHelper.INVALID_PLAYER):
		return null;

	return PlayerHelper.query_player_id_interface(ownerId, iid);
