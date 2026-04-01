member loc toLocation;
member string keyword;
member int range;

trigger speech("*") {
	if (!isPlayer(speaker)) { return(0x01); }
	if (!strContains(arg, keyword)) { return(0x01); }
	loc speakerLoc = getLocation(speaker);
	loc myLoc = getLocation(this);
	int dx = getX(speakerLoc) - getX(myLoc);
	int dy = getY(speakerLoc) - getY(myLoc);
	if (dx > range || dx < (0x00 - range)) { return(0x01); }
	if (dy > range || dy < (0x00 - range)) { return(0x01); }
	teleport(speaker, toLocation);
	return(0x00);
}
