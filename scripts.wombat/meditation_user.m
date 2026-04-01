inherits globals;

trigger message("breakMeditation") {
	removeObjVar(this, "meditating");
	detachScript(this, "meditation_user");
	barkToHued(this, this, 0x22, "You stop meditating.");
	return(0x00);
}

trigger message("manaFull") {
	removeObjVar(this, "meditating");
	detachScript(this, "meditation_user");
	barkToHued(this, this, 0x22, "You are at peace.");
	return(0x00);
}

trigger message("gotHit") {
	removeObjVar(this, "meditating");
	detachScript(this, "meditation_user");
	barkToHued(this, this, 0x22, "You stop meditating.");
	return(0x01);
}

trigger serverswitch {
	return(0x01);
}
