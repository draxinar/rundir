inherits housestuff;

trigger speech("*i wish to lock this down*") {
	obj multi = getMultiSlaveId(this);
	if (!Q4X6(multi, speaker)) {
		return(0x01);
	}
	systemMessage(speaker, "Lock what down?");
	setObjVar(this, "cmdSpeaker", speaker);
	setObjVar(this, "cmdAction", 0x01);
	targetObj(speaker, this);
	return(0x01);
}

trigger speech("*i wish to release this*") {
	obj multi = getMultiSlaveId(this);
	if (!Q4X6(multi, speaker)) {
		return(0x01);
	}
	systemMessage(speaker, "Choose the item you wish to release");
	setObjVar(this, "cmdSpeaker", speaker);
	setObjVar(this, "cmdAction", 0x02);
	targetObj(speaker, this);
	return(0x01);
}

trigger speech("*i wish to secure this*") {
	obj multi = getMultiSlaveId(this);
	if (!Q4X6(multi, speaker)) {
		return(0x01);
	}
	systemMessage(speaker, "Choose the item you wish to secure");
	setObjVar(this, "cmdSpeaker", speaker);
	setObjVar(this, "cmdAction", 0x03);
	targetObj(speaker, this);
	return(0x01);
}

trigger speech("*i wish to unsecure this*") {
	obj multi = getMultiSlaveId(this);
	if (!Q4X6(multi, speaker)) {
		return(0x01);
	}
	systemMessage(speaker, "Choose the item you wish to unsecure");
	setObjVar(this, "cmdSpeaker", speaker);
	setObjVar(this, "cmdAction", 0x04);
	targetObj(speaker, this);
	return(0x01);
}

trigger speech("*i ban thee*") {
	obj multi = getMultiSlaveId(this);
	if (!Q4X6(multi, speaker)) {
		return(0x01);
	}
	systemMessage(speaker, "Target the individual to ban from this house.");
	setObjVar(this, "cmdSpeaker", speaker);
	setObjVar(this, "cmdAction", 0x07);
	targetObj(speaker, this);
	return(0x01);
}

trigger speech("*remove thyself*") {
	obj multi = getMultiSlaveId(this);
	if (!Q4X6(multi, speaker)) {
		return(0x01);
	}
	systemMessage(speaker, "Target the individual to eject from this house.");
	setObjVar(this, "cmdSpeaker", speaker);
	setObjVar(this, "cmdAction", 0x08);
	targetObj(speaker, this);
	return(0x01);
}

trigger targetobj {
	if (!hasObjVar(this, "cmdAction")) {
		return(0x01);
	}

	obj speaker = getObjVar(this, "cmdSpeaker");
	int action = getObjVar(this, "cmdAction");
	removeObjVar(this, "cmdAction");
	removeObjVar(this, "cmdSpeaker");

	obj multi = getMultiSlaveId(this);

	if (!Q4X6(multi, speaker)) {
		systemMessage(speaker, "You must be in your house to do this.");
		return(0x01);
	}

	if (action == 0x01) {
		if (hasScript(usedon, "lockdown")) {
			systemMessage(speaker, "This is already locked down!");
			return(0x01);
		}
		if (isMultiComp(usedon)) {
			systemMessage(speaker, "You cannot lock that down!");
			return(0x01);
		}
		attachScript(usedon, "lockdown");
		systemMessage(speaker, "Locked down!");
		return(0x01);
	}

	if (action == 0x02) {
		if (hasScript(usedon, "lockdown")) {
			detachScript(usedon, "lockdown");
			bark(usedon, "(no longer locked down)");
		} else {
			if (hasObjVar(usedon, "securedBy")) {
				detachScript(usedon, "lockdown");
				removeObjVar(usedon, "securedBy");
				bark(usedon, "(no longer secure)");
			} else {
				systemMessage(speaker, "This isn't locked down...");
			}
		}
		return(0x01);
	}

	if (action == 0x03) {
		if (hasObjVar(usedon, "securedBy")) {
			systemMessage(speaker, "This is already secure!");
			return(0x01);
		}
		attachScript(usedon, "lockdown");
		setObjVar(usedon, "securedBy", speaker);
		systemMessage(speaker, "Secure!");
		return(0x01);
	}

	if (action == 0x04) {
		if (hasObjVar(usedon, "securedBy")) {
			detachScript(usedon, "lockdown");
			removeObjVar(usedon, "securedBy");
			bark(usedon, "(no longer secure)");
		} else {
			systemMessage(speaker, "This isn't secure...");
		}
		return(0x01);
	}

	if (action == 0x07) {
		if (!isPlayer(usedon)) {
			systemMessage(speaker, "You cannot eject that from the house!");
			return(0x01);
		}
		list banned;
		if (hasObjListVar(multi, "bannedPlayers")) {
			getObjListVar(banned, multi, "bannedPlayers");
		}
		if (isInList(banned, usedon)) {
			systemMessage(speaker, "This person is already banned!");
			return(0x01);
		}
		appendToList(banned, usedon);
		setObjVar(multi, "bannedPlayers", banned);
		string name = getName(usedon);
		string msg = name;
		concat(msg, " has been banned from this house.");
		systemMessage(speaker, msg);
		systemMessage(usedon, "You have been banned from this house.");
		loc banLoc = getLocation(this);
		moveDir(banLoc, 0x04);
		moveDir(banLoc, 0x04);
		moveDir(banLoc, 0x04);
		teleport(usedon, banLoc);
		return(0x01);
	}

	if (action == 0x08) {
		if (!isPlayer(usedon)) {
			systemMessage(speaker, "You cannot eject that from the house!");
			return(0x01);
		}
		loc banLoc = getLocation(this);
		moveDir(banLoc, 0x04);
		moveDir(banLoc, 0x04);
		moveDir(banLoc, 0x04);
		teleport(usedon, banLoc);
		string name = getName(usedon);
		string msg = name;
		concat(msg, " has been ejected from this house.");
		systemMessage(speaker, msg);
		systemMessage(usedon, "You have been ejected from this house. If you persist in entering, you may be banned from the house.");
		return(0x01);
	}

	return(0x01);
}
