function void giveToUser(obj user, obj item, string label) {
	obj bp = getBackpack(user);
	string msg = label;
	if (isValid(bp) && canHold(bp, item)) {
		concat(msg, " in your backpack.");
		int r = putObjContainer(item, bp);
	} else {
		concat(msg, " at your feet.");
	}
	systemMessage(user, msg);
	return();
}

function int harvestResource(obj user, obj target, string resName, int dropBodyId, string label) {
	int value;
	int q = getResource(value, target, resName, 0x03, 0x02);
	if (value <= 0x00) {
		return(0x00);
	}
	obj drop = createNoResObjectAt(dropBodyId, getLocation(user));
	transferResources(drop, target, value, resName);
	giveToUser(user, drop, label);
	returnResourcesToBank(target, value, resName);
	return(0x01);
}

trigger use {
	if (user == NULL()) {
		return(0x00);
	}
	if (getDistanceInTiles(getLocation(user), getLocation(this)) > 0x03) {
		systemMessage(user, "That is too far away.");
		return(0x00);
	}
	int any = 0x00;
	any = any + harvestResource(user, this, "wood", 0x1BDD, "You harvest some logs");
	any = any + harvestResource(user, this, "meat", 0x09F1, "You harvest some meat");
	any = any + harvestResource(user, this, "leather", 0x1078, "You harvest some leather");
	any = any + harvestResource(user, this, "fur", 0x11F4, "You harvest some fur");
	any = any + harvestResource(user, this, "feathers", 0x1BD1, "You harvest some feathers");
	any = any + harvestResource(user, this, "cloth", 0x101F, "You harvest some wool");
	any = any + harvestResource(user, this, "fish", 0x097A, "You harvest some fish");
	if (any == 0x00) {
		systemMessage(user, "There is nothing useful here to harvest.");
	}
	return(0x00);
}
