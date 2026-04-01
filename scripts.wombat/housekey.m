inherits housestuff;

trigger creation {
	setObjVar(this, "predesc", "a house key");
	setObjVar(this, "lookAtText", "a house key");
	return(0x01);
}

function void Q53Q(obj it) {
	attachScript(it, "lockdown");
	return();
}

function void Q666(obj it) {
	detachScript(it, "lockdown");
	return();
}

function int Q50T(obj it) {
	return(hasScript(it, "lockdown"));
}

function int Q4X7(obj key, obj house) {
	list Q667;
	getObjListVar(Q667, key, "whatIUnlock");
	list Q5Z5;
	if (hasObjVar(house, "myhousedoors")) {
		getObjListVar(Q5Z5, house, "myhousedoors");
	}
	int Q55T = numInList(Q5Z5);
	for (int Q4EJ = 0x00; Q4EJ < Q55T; Q4EJ++) {
		if (isInList(Q667, Q5Z5[Q4EJ])) {
			return(0x01);
		}
	}
	return(0x00);
}

function int Q4X8(obj key, obj Q68S, obj it) {
	loc where = getLocation(Q68S);
	obj house = Q4YP(Q68S, where);
	if (!isValid(house)) {
		systemMessage(Q68S, "You are not around your house.");
		return(0x00);
	}
	if (!Q4X7(key, house)) {
		systemMessage(Q68S, "This key is not for this house.");
		return(0x00);
	}
	if (Q50T(it)) {
		Q666(it);
		systemMessage(Q68S, "You release that locked down object.");
	} else {
		Q53Q(it);
		systemMessage(Q68S, "You lock that down.");
	}
	return(0x01);
}

function int Q4VG(obj it) {
	return(hasScript(it, "locked"));
}

function int Q51P(obj key, obj it) {
	list Q667;
	getObjListVar(Q667, key, "whatIUnlock");
	return(isInList(Q667, it));
}
