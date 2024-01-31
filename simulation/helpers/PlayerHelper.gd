# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Node
class_name PlayerHelper

static var INVALID_PLAYER: int = -1

static func QueryPlayerIDInterface(id:int, iid:int = ICmpPlayer.IID_Player):
	var cmpPlayerManager = PyrogenesisEngine.QueryInterface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpPlayerManager.IID_PlayerManager);

	var playerEnt = cmpPlayerManager.GetPlayerByID(id);
	if !playerEnt:
		return null;

	return PyrogenesisEngine.QueryInterface(playerEnt, iid);


static func query_owner_interface(ent: int, iid: int = ICmpPlayer.IID_Player):
	var cmpOwnership = PyrogenesisEngine.QueryInterface(ent, ICmpOwnership.IID_Ownership);
	if (!cmpOwnership):
		return null;

	var owner = cmpOwnership.GetOwner();
	if (owner == PlayerHelper.INVALID_PLAYER):
		return null;

	return QueryPlayerIDInterface(owner, iid);
