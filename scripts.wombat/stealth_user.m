inherits globals;

trigger message("stealthStep") {
	int steps = getObjVar(this, "stealthSteps");
	steps = steps - 0x01;
	if (steps <= 0x00) {
		removeObjVar(this, "stealthSteps");
		Q661(this);
		barkToHued(this, this, 0x22, "You are no longer hidden.");
		detachScript(this, "stealth_user");
	} else {
		setObjVar(this, "stealthSteps", steps);
	}
	return(0x01);
}

trigger message("stealthBreak") {
	removeObjVar(this, "stealthSteps");
	detachScript(this, "stealth_user");
	return(0x01);
}

trigger message("uninvis") {
	removeObjVar(this, "stealthSteps");
	detachScript(this, "stealth_user");
	return(0x01);
}

trigger serverswitch {
	return(0x01);
}
