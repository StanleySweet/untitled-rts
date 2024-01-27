# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpWallPiece
class_name CmpWallPiece

## Meters. Used in rmgen wallbuilder and the in-game wall-placer.
@export_range(0.0, INF) var Length: float
## Multiples of Pi, measured anti-clockwise. Default: 1;
## full revolution: 2. Used in rmgen wallbuilder.
## How the wallpiece should be rotated so it is orientated
## the same way as every other wallpiece: with the "line"
## of the wall running along a map&apos;s `z` axis and the
## "outside face" towards positive `x`. If the piece bends
## (see below), the orientation should be that of the start
## of the wallpiece, not the middle.
@export_range(0.0, INF) var Orientation: float
## Meters. Default: 0. Used in rmgen wallbuilder. Permits piece to
## be placed in front (-ve value) or behind (+ve value) a wall.
@export var Indent: float = 0.0
## Multiples of Pi, measured anti-clockwise. Default: 0. Used in
## rmgen wallbuilder. The difference in orientation between
## the ends of a wallpiece.
@export var Bend: float
