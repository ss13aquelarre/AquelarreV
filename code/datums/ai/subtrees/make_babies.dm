/**
 * Reproduce with a similar mob.
 */
/datum/ai_planning_subtree/make_babies
	operational_datums = list(/datum/component/breed)
	///chance to make babies
	var/chance = 10
	///make babies behavior we will use
	var/datum/ai_behavior/reproduce_behavior = /datum/ai_behavior/make_babies

/datum/ai_planning_subtree/make_babies/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()

	if(!SPT_PROB(chance, seconds_per_tick))
		return
	var/mob/living/simple_animal/mob = controller.pawn
	if(mob.food < mob.food_max * 0.15)
		return
	if(controller.blackboard_key_exists(BB_BABIES_TARGET))
		controller.queue_behavior(reproduce_behavior, BB_BABIES_TARGET, BB_BABIES_CHILD_TYPES)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(controller.pawn.gender == FEMALE || !controller.blackboard[BB_BREED_READY])
		return

	var/partner_types = controller.blackboard[BB_BABIES_PARTNER_TYPES]
	var/baby_types = controller.blackboard[BB_BABIES_CHILD_TYPES]

	if(!partner_types || !baby_types)
		return

	// Baby can't reproduce
	if(is_type_in_list(controller.pawn, baby_types))
		return

	// Find target
	controller.queue_behavior(/datum/ai_behavior/find_partner, BB_BABIES_TARGET, BB_BABIES_PARTNER_TYPES, BB_BABIES_CHILD_TYPES)
