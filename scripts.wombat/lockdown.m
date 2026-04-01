inherits housestuff;

trigger wasgotten {
	systemMessage(getter, "That is locked down.");
	return(0x00);
}

trigger decay {
	loc where = getLocation(this);
	list Q4ND;
	getObjectsInRange(Q4ND, where, 0x01);
	int num = numInList(Q4ND);
	for (int i = 0x00; i < num; i++) {
		obj it = Q4ND[i];
		if (isMultiComp(it)) {
			return(0x00);
		}
	}
	return(0x01);
}
