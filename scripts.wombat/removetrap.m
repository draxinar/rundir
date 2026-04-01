inherits globals;

trigger message("canUseSkill") {
	return(0x00);
}

trigger callback(0x4D) {
	detachScript(this, "removetrap");
	return(0x00);
}

trigger message("useSkill") {
	callback(this, 0x0A, 0x4D);
	systemMessage(this, "Which trap will you attempt to disarm?");
	targetObj(this, this);
	return(0x00);
}

trigger targetobj {
	if (usedon == NULL()) {
		return(0x00);
	}
	loc Q4VS = getLocation(user);
	loc there = getLocation(usedon);
	if (getDistanceInTiles(Q4VS, there) > 0x03) {
		bark(user, "I am too far away to do that.");
		return(0x00);
	}
	if (!hasObjVar(usedon, "trapLevel")) {
		systemMessage(user, "That doesn't appear to be trapped.");
		return(0x00);
	}
	int Q52T = getObjVar(usedon, "trapLevel");
	list Q63G = user, usedon;
	if (testSkill(user, 0x30)) {
		systemMessage(user, "You successfully render the trap harmless.");
		message(usedon, "removeTrap", Q63G);
	} else {
		int mod = Q52T * 0x0A;
		if (random(0x00, 0xFA) < mod) {
			systemMessage(user, "You set off a trap!");
			message(usedon, "triggerTrap", Q63G);
		} else {
			systemMessage(user, "You fail to disarm the trap, but you don't set it off.");
		}
	}
	return(0x00);
}
