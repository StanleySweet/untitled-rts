class_name CommandsHelper

## Incur the player with the cost of a bribe, optionally multiply the cost with
## the additionalMultiplier
static func incur_bribe_cost(template, player: int, playerBribed: int, failedBribe : bool):
	var cmpPlayerBribed = PlayerHelper.QueryPlayerIDInterface(playerBribed);
	if !cmpPlayerBribed:
		return false;

	var costs = {};
	# Additional cost for this owner
	var multiplier = cmpPlayerBribed.GetSpyCostMultiplier();
	if failedBribe:
		multiplier *= template.VisionSharing.FailureCostRatio;

	#for var res in template.Cost.Resources:
		#costs[res] = Math.floor(multiplier * ApplyValueModificationsToTemplate("Cost/Resources/" + res, +template.Cost.Resources[res], player, template));
#
	#var cmpPlayer = QueryPlayerIDInterface(player);
	#return cmpPlayer && cmpPlayer.TrySubtractResources(costs);
