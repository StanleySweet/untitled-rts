# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Node
class_name PlayerHelper


static func QueryPlayerIDInterface(id, iid = ICmpPlayer.IID_Player):
	var cmpPlayerManager = PyrogenesisEngine.QueryInterface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpPlayerManager.IID_PlayerManager);

	var playerEnt = cmpPlayerManager.GetPlayerByID(id);
	if !playerEnt:
		return null;

	return PyrogenesisEngine.QueryInterface(playerEnt, iid);
