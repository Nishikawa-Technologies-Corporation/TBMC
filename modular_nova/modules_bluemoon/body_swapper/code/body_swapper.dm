GLOBAL_LIST_EMPTY(ckeys_to_mobs)

/client/proc/get_bodies()
	if(!(ckey in GLOB.ckeys_to_mobs))
		return
	var/list/datum/weakref/ref_list = GLOB.ckeys_to_mobs[ckey]
	if(!length(ref_list))
		return
	var/list/mob/living/mob_list = list()
	for(var/datum/weakref/body_ref in ref_list)
		var/mob/living/target_mob = body_ref.resolve()
		if(isnull(target_mob))
			ref_list -= body_ref
			qdel(body_ref)
			continue
		mob_list += target_mob
	if(length(mob_list))
		return mob_list

/client/proc/register_body(mob/living/target_mob, target_ckey)
	if(isnull(target_ckey))
		if(isnull(ckey))
			CRASH("No ckey was passed to /client/proc/register_body()")
		target_ckey = ckey
	target_ckey = ckey(target_ckey)
	var/list/mob/living/mob_list = get_bodies()
	if(isnull(mob_list))
		GLOB.ckeys_to_mobs[target_ckey] = list()
	else if(mob_list.Find(target_mob))
		return
	GLOB.ckeys_to_mobs[target_ckey] += WEAKREF(target_mob)
