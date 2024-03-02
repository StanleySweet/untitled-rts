# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpSoundManager
static var IID = PyrogenesisEngine.register_interface(ICmpSoundManager)

static func play_sound(_sound : String, _ent : int):
    pass;