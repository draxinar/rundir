inherits spelskil;

trigger message("canUseSkill") {
	return(0x00);
}

trigger callback(0x4D) {
	detachScript(this, "stealth");
	return(0x00);
}

trigger message("useSkill") {
	callback(this, 0x0A, 0x4D);
	if (!isInvisible(this)) {
		barkToHued(this, this, 0x22, "You must hide first");
		return(0x00);
	}
	if (getSkillLevel(this, 0x15) < 80) {
		barkToHued(this, this, 0x22, "You are not hidden well enough.  Become better at hiding.");
		return(0x00);
	}
	if (!testSkill(this, 0x2F)) {
		setInvisible(this, 0x00);
		barkToHued(this, this, 0x22, "You fail in your attempt to move unnoticed.");
		return(0x00);
	}
	int maxSteps = getSkillLevel(this, 0x2F) / 10;
	if (maxSteps < 0x01) {
		maxSteps = 0x01;
	}
	setObjVar(this, "stealthSteps", maxSteps);
	attachScript(this, "stealth_user");
	barkToHued(this, this, 0x01F4, "You begin to move quietly.");
	return(0x00);
}
