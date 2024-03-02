# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name CmpAttackDetectionSchema

## Any attacks within this range in meters will replace the previous attack suppression
@export_range(0, INF) var SuppressionTransferRange : float
## Other attacks within this range in meters will not be registered
@export_range(0, INF) var SuppressionRange : float
## Other attacks within this time in milliseconds will not be registered
@export_range(0, INF) var SuppressionTime : int
