inherits multistuff;

member int Q4H2;

trigger decay {
	obj Q5AK = getMultiSlaveId(this);
	int Q4H6 = getobjvar_int(Q5AK, "decayvisits");
	if (Q4H6 < 0x0B40) {
		Q4H6 = Q4H6 + 0x01;
		setObjVar(Q5AK, "decayvisits", Q4H6);
		return(0x00);
	}
	resetMultiCarriedDecay(Q5AK);
	int Q4H4 = 0x01;
	intRet(Q4H4);
	return(0x01);
}
