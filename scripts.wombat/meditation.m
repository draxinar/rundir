inherits spelskil;

trigger message("canUseSkill") {
	return(0x00);
}

trigger callback(0x4D) {
	detachScript(this, "meditation");
	return(0x00);
}

trigger message("useSkill") {
	callback(this, 0x0A, 0x4D);
	if (hasObjVar(this, "meditating")) {
		barkToHued(this, this, 0x22, "You are busy doing something else and cannot focus.");
		return(0x00);
	}
	if (getCurMana(this) >= getMaxMana(this)) {
		barkToHued(this, this, 0x22, "You are at peace.");
		return(0x00);
	}
	if (!testSkill(this, 0x2E)) {
		barkToHued(this, this, 0x22, "You cannot focus your concentration.");
		return(0x00);
	}
	barkToHued(this, this, 0x01F4, "You enter a meditative trance.");
	sfx(getLocation(this), 0x00F9, 0x00);
	setObjVar(this, "meditating", 0x01);
	attachScript(this, "meditation_user");
	return(0x00);
}
