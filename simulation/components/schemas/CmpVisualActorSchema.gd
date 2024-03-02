# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name CmpVisualActorSchema

enum ESelectionShape {
	## Determines the selection box based on the model bounds
	Bounds,
	## Determines the selection box based on the entity Footprint component
	Footprint,
	## Sets the selection shape to a box of specified dimensions
	Box,
	## Sets the selection shape to a cylinder of specified dimensions
	Cylinder
}

## Filename of the actor to be used for this unit
@export var Actor: PackedScene
## Filename of the actor to be used the foundation while this unit is being constructed
@export var FoundationActor: PackedScene
## Used internally; if present, the unit will be rendered as a foundation
@export var Foundation: bool
## If present, the unit should have a construction preview
@export var ConstructionPreview : bool
## Used internally; if present, shadows will be disabled
@export var DisableShadows : bool
## Used internally; if present, the unit will only be rendered if the user has high enough graphical settings.
@export var ActorOnly : bool
@export var SilhouetteDisplay : bool
@export var SilhouetteOccluder : bool
@export var VisibleInAtlasOnly : bool
@export var SelectionShape: ESelectionShape
				#"<element name='SelectionShape'>"
					#"<choice>"
						#"<element name='Bounds' a:help=''>"
							#"<empty/>"
						#"</element>"
						#"<element name='Footprint' a:help=''>"
							#"<empty/>"
						#"</element>"
						#"<element name='Box' a:help=''>"
							#"<attribute name='width'>"
								#"<data type='decimal'>"
									#"<param name='minExclusive'>0.0</param>"
								#"</data>"
							#"</attribute>"
							#"<attribute name='height'>"
								#"<data type='decimal'>"
									#"<param name='minExclusive'>0.0</param>"
								#"</data>"
							#"</attribute>"
							#"<attribute name='depth'>"
								#"<data type='decimal'>"
									#"<param name='minExclusive'>0.0</param>"
								#"</data>"
							#"</attribute>"
						#"</element>"
						#"<element name='Cylinder' a:help=''>"
							#"<attribute name='radius'>"
								#"<data type='decimal'>"
									#"<param name='minExclusive'>0.0</param>"
								#"</data>"
							#"</attribute>"
							#"<attribute name='height'>"
								#"<data type='decimal'>"
									#"<param name='minExclusive'>0.0</param>"
								#"</data>"
							#"</attribute>"
						#"</element>"
					#"</choice>"
				#"</element>"
			#"</optional>"

