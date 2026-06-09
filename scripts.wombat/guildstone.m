inherits guildbase;

member loc QGMasterLoc = 0x00, 0x00, (0x00 - 0x50);

member obj QGMenuUser;

member obj QGMenuTarget;

member int QGMenuMode;

member int QGMenuPage;

member int QGTargetMode;

member int QGPendingNoAbbr;

member string QGPendingAbbr;

member string QGPendingName;

function string QGName() {
	if (!hasObjVar(this, "guildName")) {
		setObjVar(this, "guildName", "a guild");
	}
	string name = getObjVar(this, "guildName");
	return(name);
}

function string QGAbbr() {
	if (hasObjVar(this, "hasGuildAbbreviation")) {
		if (hasObjVar(this, "guildAbbreviation")) {
			string abbr = getObjVar(this, "guildAbbreviation");
			return(abbr);
		}
	}
	return(QGName());
}

function string QGWebsite() {
	if (!hasObjVar(this, "guildWebsite")) {
		setObjVar(this, "guildWebsite", "http://www.ultimaonline.com");
	}
	string site = getObjVar(this, "guildWebsite");
	return(site);
}

function string QGCharter() {
	if (!hasObjVar(this, "guildCharter")) {
		setObjVar(this, "guildCharter", "No charter has been set.");
	}
	string charter = getObjVar(this, "guildCharter");
	return(charter);
}

function string QGMasterTitle() {
	if (!hasObjVar(this, "guildmasterTitle")) {
		setObjVar(this, "guildmasterTitle", "Guildmaster");
	}
	string title = getObjVar(this, "guildmasterTitle");
	return(title);
}

function void QGEnsure() {
	if (!hasObjVar(this, "guildMembers")) {
		list guildMembers;
		setObjVar(this, "guildMembers", guildMembers);
	}
	if (!hasObjVar(this, "guildCandidates")) {
		list guildCandidates;
		setObjVar(this, "guildCandidates", guildCandidates);
	}
	if (!hasObjVar(this, "guildAccepted")) {
		list guildAccepted;
		setObjVar(this, "guildAccepted", guildAccepted);
	}
	if (!hasObjVar(this, "guildAbbreviation")) {
		setObjVar(this, "guildAbbreviation", QGName());
	}
	if (!hasObjVar(this, "guildWebsite")) {
		setObjVar(this, "guildWebsite", "http://www.ultimaonline.com");
	}
	if (!hasObjVar(this, "guildCharter")) {
		setObjVar(this, "guildCharter", "No charter has been set.");
	}
	if (!hasObjVar(this, "guildmasterTitle")) {
		setObjVar(this, "guildmasterTitle", "Guildmaster");
	}
	if (!hasObjVar(this, "nextJoinOrder")) {
		setObjVar(this, "nextJoinOrder", 0x00);
	}
	setObjVar(this, "guildType", 0x00);
	setObjVar(this, "lookAtText", "The Guildstone for " + QGName());
	return();
}

function int QGNextOrder() {
	QGEnsure();
	int order = getObjVar(this, "nextJoinOrder");
	setObjVar(this, "nextJoinOrder", order + 0x01);
	return(order);
}

function int QGFindMember(obj player) {
	list members;
	if (!hasObjVar(this, "guildMembers")) {
		return(0x00 - 0x01);
	}
	getObjListVar(members, this, "guildMembers");
	for (int i = 0x00; i < numInList(members); i++) {
		obj guildMember = oprlist(members[i], 0x00);
		if (guildMember == player) {
			return(i);
		}
	}
	return(0x00 - 0x01);
}

function int QGFindMemberByName(string name) {
	list members;
	if (!hasObjVar(this, "guildMembers")) {
		return(0x00 - 0x01);
	}
	getObjListVar(members, this, "guildMembers");
	for (int i = 0x00; i < numInList(members); i++) {
		string memberName = oprlist(members[i], 0x01);
		if (memberName == name) {
			return(i);
		}
	}
	return(0x00 - 0x01);
}

function int QGFindCandidate(obj player) {
	list candidates;
	if (!hasObjVar(this, "guildCandidates")) {
		return(0x00 - 0x01);
	}
	getObjListVar(candidates, this, "guildCandidates");
	for (int i = 0x00; i < numInList(candidates); i++) {
		obj candidate = oprlist(candidates[i], 0x00);
		if (candidate == player) {
			return(i);
		}
	}
	return(0x00 - 0x01);
}

function int QGFindAccepted(obj player) {
	list accepted;
	if (!hasObjVar(this, "guildAccepted")) {
		return(0x00 - 0x01);
	}
	getObjListVar(accepted, this, "guildAccepted");
	for (int i = 0x00; i < numInList(accepted); i++) {
		obj candidate = oprlist(accepted[i], 0x00);
		if (candidate == player) {
			return(i);
		}
	}
	return(0x00 - 0x01);
}

function int QGMemberCount() {
	list members;
	if (!hasObjVar(this, "guildMembers")) {
		return(0x00);
	}
	getObjListVar(members, this, "guildMembers");
	return(numInList(members));
}

function obj QGMemberObj(int index) {
	list members;
	getObjListVar(members, this, "guildMembers");
	if ((index < 0x00) || (index >= numInList(members))) {
		return(NULL());
	}
	obj guildMember = oprlist(members[index], 0x00);
	return(guildMember);
}

function int QGMemberOrder(obj player) {
	int index = QGFindMember(player);
	if (index < 0x00) {
		return(0x7FFFFFFF);
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	int order = oprlist(members[index], 0x05);
	return(order);
}

function obj QGStoredLeader() {
	if (hasObjVar(this, "guildLeader")) {
		obj leader = getObjVar(this, "guildLeader");
		if (QGFindMember(leader) >= 0x00) {
			return(leader);
		}
	}
	if (QGMemberCount() > 0x00) {
		return(QGMemberObj(0x00));
	}
	return(NULL());
}

function obj QGFealtyRoot(obj voter) {
	obj start = voter;
	obj current = voter;
	list seen;
	list members;
	getObjListVar(members, this, "guildMembers");
	for (int i = 0x00; i < numInList(members); i++) {
		if (isInList(seen, current)) {
			return(start);
		}
		appendToList(seen, current);
		int index = QGFindMember(current);
		if (index < 0x00) {
			return(start);
		}
		obj next = oprlist(members[index], 0x04);
		if (next == NULL()) {
			return(current);
		}
		if (next == current) {
			return(current);
		}
		if (QGFindMember(next) < 0x00) {
			return(start);
		}
		current = next;
	}
	return(start);
}

function int QGSupportCount(obj candidate) {
	list members;
	getObjListVar(members, this, "guildMembers");
	int count = 0x00;
	for (int i = 0x00; i < numInList(members); i++) {
		obj voter = oprlist(members[i], 0x00);
		if (QGFealtyRoot(voter) == candidate) {
			count++;
		}
	}
	return(count);
}

function obj QGRecalcLeader() {
	list members;
	getObjListVar(members, this, "guildMembers");
	if (numInList(members) == 0x00) {
		removeObjVar(this, "guildLeader");
		return(NULL());
	}
	obj oldLeader = QGStoredLeader();
	obj best = NULL();
	int bestCount = 0x00 - 0x01;
	int bestOrder = 0x7FFFFFFF;
	for (int i = 0x00; i < numInList(members); i++) {
		obj candidate = oprlist(members[i], 0x00);
		int count = QGSupportCount(candidate);
		int order = oprlist(members[i], 0x05);
		if ((count > bestCount) || ((count == bestCount) && (order < bestOrder))) {
			best = candidate;
			bestCount = count;
			bestOrder = order;
		}
	}
	if (QGFindMember(oldLeader) >= 0x00) {
		if (QGSupportCount(oldLeader) == bestCount) {
			best = oldLeader;
		}
	}
	setObjVar(this, "guildLeader", best);
	return(best);
}

function void QGRegister(string messageName) {
	list info = this, QGName(), QGAbbr(), 0x00;
	multiMessageToLoc(QGMasterLoc, messageName, info);
	return();
}

function void QGClearPlayer(obj player) {
	if (!isValid(player)) {
		return();
	}
	list args;
	message(player, "removedFromGuild", args);
	return();
}

function void QGSendUpdate(obj player) {
	if (!isValid(player)) {
		return();
	}
	int index = QGFindMember(player);
	if (index < 0x00) {
		removeObjVar(player, "guildstoneId");
		removeObjVar(player, "displayGuildAbbr");
		list emptyOpposing;
		list gone = 0x00, QGName(), QGAbbr(), 0x00, " ", NULL(), QGMasterTitle(), emptyOpposing;
		message(player, "updateGuildInfo", gone);
		return();
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	string title = oprlist(members[index], 0x02);
	int display = oprlist(members[index], 0x03);
	if (display) {
		setObjVar(player, "displayGuildAbbr", 0x01);
	} else {
		removeObjVar(player, "displayGuildAbbr");
	}
	setObjVar(player, "guildstoneId", this);
	list opposingGuilds;
	obj leader = QGRecalcLeader();
	list update = 0x01, QGName(), QGAbbr(), 0x00, title, leader, QGMasterTitle(), opposingGuilds;
	message(player, "updateGuildInfo", update);
	setObjVar(player, "guildType", 0x00);
	return();
}

function void QGUpdateAll() {
	list members;
	getObjListVar(members, this, "guildMembers");
	for (int i = 0x00; i < numInList(members); i++) {
		obj guildMember = oprlist(members[i], 0x00);
		QGSendUpdate(guildMember);
	}
	return();
}

function void QGNotifyMembers(string text) {
	list members;
	getObjListVar(members, this, "guildMembers");
	list msg = text;
	for (int i = 0x00; i < numInList(members); i++) {
		obj guildMember = oprlist(members[i], 0x00);
		if (isValid(guildMember)) {
			message(guildMember, "guildMessage", msg);
		}
	}
	return();
}

function void QGNotifyGlobal(string text) {
	list members;
	getObjListVar(members, this, "guildMembers");
	list msg = text;
	for (int i = 0x00; i < numInList(members); i++) {
		obj guildMember = oprlist(members[i], 0x00);
		if (isValid(guildMember)) {
			message(guildMember, "globalGuildMessage", msg);
		}
	}
	return();
}

function void QGDisband() {
	list members;
	getObjListVar(members, this, "guildMembers");
	for (int i = 0x00; i < numInList(members); i++) {
		obj guildMember = oprlist(members[i], 0x00);
		if (isValid(guildMember)) {
			list args;
			message(guildMember, "guildGone", args);
		}
	}
	if (hasObjVar(this, "myHome")) {
		obj myHome = getObjVar(this, "myHome");
		if (myHome != NULL()) {
			Q58T(myHome);
		}
	}
	list dead = this;
	multiMessageToLoc(QGMasterLoc, "deadGuild", dead);
	deleteObject(this);
	return();
}

function void QGAddMember(obj player) {
	QGEnsure();
	if (QGFindMember(player) >= 0x00) {
		QGSendUpdate(player);
		return();
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	int order = QGNextOrder();
	list record = player, Q4RE(player), " ", 0x01, player, order;
	appendToList(members, record);
	setObjVar(this, "guildMembers", members);
	if (!hasObjVar(this, "guildLeader")) {
		setObjVar(this, "guildLeader", player);
	}
	QGRecalcLeader();
	QGSendUpdate(player);
	QGNotifyMembers(Q4RE(player) + " has joined the guild.");
	return();
}

function void QGRemoveMember(obj player, int clearPlayer) {
	list members;
	getObjListVar(members, this, "guildMembers");
	int index = QGFindMember(player);
	if (index < 0x00) {
		if (clearPlayer) {
			QGClearPlayer(player);
		}
		return();
	}
	if (numInList(members) == 0x01) {
		QGDisband();
		return();
	}
	removeItem(members, index);
	for (int i = 0x00; i < numInList(members); i++) {
		obj guildMember = oprlist(members[i], 0x00);
		obj fealty = oprlist(members[i], 0x04);
		if (fealty == player) {
			string name = oprlist(members[i], 0x01);
			string title = oprlist(members[i], 0x02);
			int display = oprlist(members[i], 0x03);
			int order = oprlist(members[i], 0x05);
			list fixed = guildMember, name, title, display, guildMember, order;
			setItem(members, fixed, i);
		}
	}
	setObjVar(this, "guildMembers", members);
	if (clearPlayer) {
		QGClearPlayer(player);
	}
	QGRecalcLeader();
	QGUpdateAll();
	QGNotifyMembers(Q4RE(player) + " is no longer a member of the guild.");
	return();
}

function void QGSetFealty(obj player, obj leader) {
	int index = QGFindMember(player);
	if (index < 0x00) {
		return();
	}
	if (QGFindMember(leader) < 0x00) {
		return();
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	string name = oprlist(members[index], 0x01);
	string title = oprlist(members[index], 0x02);
	int display = oprlist(members[index], 0x03);
	int order = oprlist(members[index], 0x05);
	list changed = player, name, title, display, leader, order;
	setItem(members, changed, index);
	setObjVar(this, "guildMembers", members);
	QGRecalcLeader();
	QGUpdateAll();
	return();
}

function void QGSetTitle(obj player, string title) {
	int index = QGFindMember(player);
	if (index < 0x00) {
		return();
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	string name = oprlist(members[index], 0x01);
	int display = oprlist(members[index], 0x03);
	obj fealty = oprlist(members[index], 0x04);
	int order = oprlist(members[index], 0x05);
	list changed = player, name, title, display, fealty, order;
	setItem(members, changed, index);
	setObjVar(this, "guildMembers", members);
	QGSendUpdate(player);
	QGNotifyMembers(name + "'s guild title has changed.");
	return();
}

function void QGToggleAbbr(obj player) {
	int index = QGFindMember(player);
	if (index < 0x00) {
		return();
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	string name = oprlist(members[index], 0x01);
	string title = oprlist(members[index], 0x02);
	int display = oprlist(members[index], 0x03);
	obj fealty = oprlist(members[index], 0x04);
	int order = oprlist(members[index], 0x05);
	if (display) {
		display = 0x00;
		systemMessage(player, "Your guild abbreviation will no longer be displayed.");
	} else {
		display = 0x01;
		systemMessage(player, "Your guild abbreviation will now be displayed.");
	}
	list changed = player, name, title, display, fealty, order;
	setItem(members, changed, index);
	setObjVar(this, "guildMembers", members);
	QGSendUpdate(player);
	return();
}

function int QGConfirmMaster(obj player) {
	if (!isValid(player)) {
		return(0x00);
	}
	if (QGRecalcLeader() != player) {
		systemMessage(player, "Only the current guild leader may access guildmaster functions.");
		QGShowMain(player);
		return(0x00);
	}
	return(0x01);
}

function int QGCanUseWeeklyChange(obj player, string varName, string changeName) {
	if (hasObjVar(this, varName)) {
		int lastChange = getObjVar(this, varName);
		int now = getTimeSecs();
		if ((now - lastChange) < 0x00093A80) {
			systemMessage(player, "You may only change your guild " + changeName + " once per real-world week.");
			return(0x00);
		}
	}
	return(0x01);
}

function int QGListPages(int count) {
	int pageSize = 0x14;
	int pages = count / pageSize;
	if ((count % pageSize) != 0x00) {
		pages++;
	}
	if (pages < 0x01) {
		pages = 0x01;
	}
	return(pages);
}

function int QGMemberDisplay(obj player) {
	int index = QGFindMember(player);
	if (index < 0x00) {
		return(0x00);
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	int display = oprlist(members[index], 0x03);
	return(display);
}

function obj QGMemberFealty(obj player) {
	int index = QGFindMember(player);
	if (index < 0x00) {
		return(NULL());
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	obj fealty = oprlist(members[index], 0x04);
	if (QGFindMember(fealty) < 0x00) {
		fealty = QGRecalcLeader();
	}
	if (fealty == NULL()) {
		fealty = player;
	}
	return(fealty);
}

function string QGFealtyName(obj player) {
	obj fealty = QGMemberFealty(player);
	if (fealty == player) {
		return(Q4RE(fealty));
	}
	if (!isValid(fealty)) {
		return("(empty)");
	}
	return(Q4RE(fealty));
}

function string QGLeaderLabel() {
	obj leader = QGRecalcLeader();
	if (!isValid(leader)) {
		return("");
	}
	string label = "Guild Master";
	if (getSex(leader) == 0x01) {
		label = "Guild Mistress";
	}
	label = label + " " + Q4RE(leader);
	return(label);
}

function string QGStoneTitle() {
	string title = QGName();
	string leader = QGLeaderLabel();
	if (leader != "") {
		title = title + " (" + leader + ")";
	}
	return(title);
}

function void QGPickerOption(list options, string text) {
	appendToList(options, 0x00);
	appendToList(options, 0x02);
	appendToList(options, text);
	return();
}

function void QGOpenPicker(obj player, int dialogId, string title, list options) {
	if (numInList(options) == 0x00) {
		QGPickerOption(options, "Return to the main menu.");
	}
	selectTypeAndHue(player, this, dialogId, title, options);
	return();
}

function void QGShowMain(obj player) {
	QGMenuUser = player;
	QGMenuPage = 0x00;
	list options;
	QGPickerOption(options, "Recruit someone into the guild.");
	QGPickerOption(options, "View the current roster.");
	QGPickerOption(options, "View the guild's charter.");
	QGPickerOption(options, "Declare your fealty. You are currently loyal to " + QGFealtyName(player) + ".");
	string toggleText = "Toggle showing the guild's abbreviation in your name to unguilded people. Currently ";
	if (QGMemberDisplay(player)) {
		toggleText = toggleText + "on.";
	} else {
		toggleText = toggleText + "off.";
	}
	QGPickerOption(options, toggleText);
	QGPickerOption(options, "Resign from the guild.");
	QGPickerOption(options, "View list of candidates who have been sponsored to the guild.");
	if (QGRecalcLeader() == player) {
		QGPickerOption(options, "Access Guild Master functions.");
	}
	QGPickerOption(options, "View list of guilds that " + QGName() + " has declared war on.");
	QGOpenPicker(player, 0x70, QGStoneTitle(), options);
	return();
}

function void QGShowGuildmaster(obj player) {
	QGMenuUser = player;
	list options;
	QGPickerOption(options, "Set the guild name.");
	QGPickerOption(options, "Set the guild's abbreviation.");
	QGPickerOption(options, "Set the guild's charter.");
	QGPickerOption(options, "Set the guild's website.");
	QGPickerOption(options, "Dismiss a member.");
	QGPickerOption(options, "Declare war.");
	QGPickerOption(options, "Accept a candidate seeking membership.");
	QGPickerOption(options, "Refuse a candidate seeking membership.");
	QGPickerOption(options, "Set the guildmaster's title.");
	QGPickerOption(options, "Grant a title to another member.");
	QGPickerOption(options, "Return to the main menu.");
	obj leader = QGRecalcLeader();
	string label = "Guild Master";
	if (isValid(leader)) {
		if (getSex(leader) == 0x01) {
			label = "Guild Mistress";
		}
	}
	QGOpenPicker(player, 0x71, QGName() + ", " + label + " functions", options);
	return();
}

function void QGShowRoster(obj player, int page) {
	QGMenuUser = player;
	list members;
	getObjListVar(members, this, "guildMembers");
	obj leader = QGRecalcLeader();
	int totalPages = QGListPages(numInList(members));
	if (page < 0x00) {
		page = 0x00;
	}
	if (page >= totalPages) {
		page = totalPages - 0x01;
	}
	QGMenuPage = page;
	list options;
	int start = page * 0x14;
	int stop = start + 0x14;
	for (int i = start; (i < stop) && (i < numInList(members)); i++) {
		obj guildMember = oprlist(members[i], 0x00);
		string name = oprlist(members[i], 0x01);
		string title = oprlist(members[i], 0x02);
		string label = name;
		if (title != " ") {
			label = label + ", " + title;
		}
		if (guildMember == leader) {
			label = label + " (" + QGMasterTitle() + ")";
		}
		QGPickerOption(options, label);
	}
	if (page > 0x00) {
		QGPickerOption(options, "Previous page");
	}
	if ((page + 0x01) < totalPages) {
		QGPickerOption(options, "Next page");
	}
	QGOpenPicker(player, 0x72, "Guild Roster", options);
	return();
}

function void QGShowCandidates(obj player) {
	QGMenuUser = player;
	list candidates;
	list accepted;
	getObjListVar(candidates, this, "guildCandidates");
	getObjListVar(accepted, this, "guildAccepted");
	list options;
	int total = numInList(candidates) + numInList(accepted);
	for (int i = 0x00; i < total; i++) {
		string name;
		if (i < numInList(candidates)) {
			name = "Sponsored: " + oprlist(candidates[i], 0x01);
		} else {
			name = "Accepted: " + oprlist(accepted[i - numInList(candidates)], 0x01);
		}
		QGPickerOption(options, name);
	}
	QGOpenPicker(player, 0x73, "Candidates", options);
	return();
}

function void QGShowMemberPicker(obj player, int mode, int page, string title) {
	QGMenuUser = player;
	QGMenuMode = mode;
	QGMenuPage = page;
	list members;
	getObjListVar(members, this, "guildMembers");
	string heading = title;
	if (mode == 0x01) {
		heading = "Declare your fealty";
	}
	if (mode == 0x02) {
		heading = "Whom do you wish to dismiss?";
	}
	if (mode == 0x03) {
		heading = "Grant a title to another member.";
	}
	int totalPages = QGListPages(numInList(members));
	if (page < 0x00) {
		page = 0x00;
	}
	if (page >= totalPages) {
		page = totalPages - 0x01;
	}
	QGMenuPage = page;
	list options;
	int start = page * 0x14;
	int stop = start + 0x14;
	for (int i = start; (i < stop) && (i < numInList(members)); i++) {
		string name = oprlist(members[i], 0x01);
		QGPickerOption(options, name);
	}
	if (page > 0x00) {
		QGPickerOption(options, "Previous page");
	}
	if ((page + 0x01) < totalPages) {
		QGPickerOption(options, "Next page");
	}
	QGOpenPicker(player, 0x74, heading, options);
	return();
}

function void QGShowCandidatePicker(obj player, int mode, int page, string title) {
	QGMenuUser = player;
	QGMenuMode = mode;
	QGMenuPage = page;
	list candidates;
	getObjListVar(candidates, this, "guildCandidates");
	if (numInList(candidates) == 0x00) {
		systemMessage(player, "There are no candidates to select.");
		QGShowGuildmaster(player);
		return();
	}
	int totalPages = QGListPages(numInList(candidates));
	if (page < 0x00) {
		page = 0x00;
	}
	if (page >= totalPages) {
		page = totalPages - 0x01;
	}
	QGMenuPage = page;
	list options;
	int start = page * 0x14;
	int stop = start + 0x14;
	for (int i = start; (i < stop) && (i < numInList(candidates)); i++) {
		string name = oprlist(candidates[i], 0x01);
		QGPickerOption(options, name);
	}
	if (page > 0x00) {
		QGPickerOption(options, "Previous page");
	}
	if ((page + 0x01) < totalPages) {
		QGPickerOption(options, "Next page");
	}
	QGOpenPicker(player, 0x75, title, options);
	return();
}

function void QGShowWarGump(obj player) {
	QGMenuUser = player;
	list options;
	QGPickerOption(options, "Guilds we are at war with");
	QGPickerOption(options, "Guilds that we have declared war on");
	QGPickerOption(options, "Guilds that have declared war on us");
	QGPickerOption(options, "Return to the main menu.");
	QGOpenPicker(player, 0x77, "WARFARE STATUS", options);
	return();
}

function void QGShowWarList(obj player, string title) {
	QGMenuUser = player;
	list options;
	QGPickerOption(options, "No current wars.");
	QGOpenPicker(player, 0x78, title, options);
	return();
}

function void QGRecruit(obj sponsor, obj target) {
	if (QGFindMember(sponsor) < 0x00) {
		return();
	}
	if (target == NULL()) {
		systemMessage(sponsor, "Recruitment cancelled.");
		QGShowMain(sponsor);
		return();
	}
	if (!isPlayer(target)) {
		systemMessage(sponsor, "Only players may be sponsored to a guild.");
		QGShowMain(sponsor);
		return();
	}
	if (target == sponsor) {
		systemMessage(sponsor, "You are already a member of this guild.");
		QGShowMain(sponsor);
		return();
	}
	if (getDistanceInTiles(getLocation(sponsor), getLocation(target)) > 0x03) {
		systemMessage(sponsor, "They must be with you when you sponsor them.");
		QGShowMain(sponsor);
		return();
	}
	if (hasObjVar(target, "guildstoneId")) {
		systemMessage(sponsor, "They must resign from their current guild first.");
		QGShowMain(sponsor);
		return();
	}
	if (QGFindMember(target) >= 0x00) {
		systemMessage(sponsor, "They are already a member of this guild.");
		QGShowMain(sponsor);
		return();
	}
	if ((QGFindCandidate(target) >= 0x00) || (QGFindAccepted(target) >= 0x00)) {
		systemMessage(sponsor, "They are already sponsored to this guild.");
		QGShowMain(sponsor);
		return();
	}
	list candidates;
	getObjListVar(candidates, this, "guildCandidates");
	if (numInList(candidates) >= 0x0C) {
		systemMessage(sponsor, "There are already a dozen candidates sponsored to this guild.");
		QGShowMain(sponsor);
		return();
	}
	list record = target, Q4RE(target), sponsor;
	appendToList(candidates, record);
	setObjVar(this, "guildCandidates", candidates);
	systemMessage(sponsor, Q4RE(target) + " has been sponsored for membership.");
	systemMessage(target, "You have been sponsored for membership in " + QGName() + ".");
	QGNotifyMembers(Q4RE(target) + " has been sponsored for membership.");
	QGShowMain(sponsor);
	return();
}

function void QGAcceptCandidate(obj player, int index) {
	list candidates;
	list accepted;
	getObjListVar(candidates, this, "guildCandidates");
	getObjListVar(accepted, this, "guildAccepted");
	if ((index < 0x00) || (index >= numInList(candidates))) {
		QGShowGuildmaster(player);
		return();
	}
	obj candidate = oprlist(candidates[index], 0x00);
	string name = oprlist(candidates[index], 0x01);
	obj sponsor = oprlist(candidates[index], 0x02);
	list record = candidate, name, sponsor;
	removeItem(candidates, index);
	if (QGFindAccepted(candidate) < 0x00) {
		appendToList(accepted, record);
	}
	setObjVar(this, "guildCandidates", candidates);
	setObjVar(this, "guildAccepted", accepted);
	if (isValid(candidate)) {
		systemMessage(candidate, "You have been accepted into " + QGName() + ". Use the guildstone to join.");
	}
	QGNotifyMembers(name + " has been accepted as a candidate.");
	QGShowGuildmaster(player);
	return();
}

function void QGRefuseCandidate(obj player, int index) {
	list candidates;
	getObjListVar(candidates, this, "guildCandidates");
	if ((index < 0x00) || (index >= numInList(candidates))) {
		QGShowGuildmaster(player);
		return();
	}
	obj candidate = oprlist(candidates[index], 0x00);
	string name = oprlist(candidates[index], 0x01);
	removeItem(candidates, index);
	setObjVar(this, "guildCandidates", candidates);
	if (isValid(candidate)) {
		systemMessage(candidate, "Your sponsorship to " + QGName() + " has been refused.");
	}
	QGNotifyMembers(name + " has been removed from the candidate list.");
	QGShowGuildmaster(player);
	return();
}

trigger creation {
	setObjVar(this, "guildType", 0x00);
	return(0x01);
}

trigger objectloaded {
	QGEnsure();
	if (QGMemberCount() > 0x00) {
		QGRegister("IAmHere");
	}
	QGRecalcLeader();
	QGUpdateAll();
	return(0x01);
}

trigger decay {
	return(0x00);
}

trigger use {
	QGEnsure();
	if (QGMemberCount() == 0x00) {
		if (hasObjVar(user, "guildstoneId")) {
			systemMessage(user, "You must resign from your current guild before joining another!");
			return(0x00);
		}
		QGAddMember(user);
		QGRegister("IAmHere");
		systemMessage(user, "You are now the guildmaster of " + QGName() + ".");
		QGShowMain(user);
		return(0x00);
	}
	if (QGFindMember(user) >= 0x00) {
		QGRegister("IAmHere");
		QGSendUpdate(user);
		QGShowMain(user);
		return(0x00);
	}
	int acceptedIndex = QGFindAccepted(user);
	if (acceptedIndex >= 0x00) {
		if (hasObjVar(user, "guildstoneId")) {
			systemMessage(user, "You must resign from your current guild before joining another!");
			return(0x00);
		}
		list accepted;
		getObjListVar(accepted, this, "guildAccepted");
		removeItem(accepted, acceptedIndex);
		setObjVar(this, "guildAccepted", accepted);
		QGAddMember(user);
		QGRegister("IAmHere");
		QGShowMain(user);
		return(0x00);
	}
	if (QGFindCandidate(user) >= 0x00) {
		systemMessage(user, "You have been sponsored to this guild, but have not yet been accepted.");
		return(0x00);
	}
	systemMessage(user, "You are not a member of this guild.");
	return(0x00);
}

trigger typeselected(0x70) {
	if (listindex == 0x00) {
		return(0x01);
	}
	if (QGFindMember(user) < 0x00) {
		systemMessage(user, "You are not a member of this guild.");
		return(0x00);
	}
	if (listindex == 0x01) {
		QGTargetMode = 0x01;
		QGMenuUser = user;
		systemMessage(user, "Whom do you wish to sponsor?");
		targetObj(user, this);
		return(0x00);
	}
	if (listindex == 0x02) {
		QGShowRoster(user, 0x00);
		return(0x00);
	}
	if (listindex == 0x03) {
		systemMessage(user, "Guild charter: " + QGCharter());
		systemMessage(user, "Guild website: " + QGWebsite());
		webBrowse(user, QGWebsite());
		QGShowMain(user);
		return(0x00);
	}
	if (listindex == 0x04) {
		QGShowMemberPicker(user, 0x01, 0x00, "Declare fealty to whom?");
		return(0x00);
	}
	if (listindex == 0x05) {
		QGToggleAbbr(user);
		QGShowMain(user);
		return(0x00);
	}
	if (listindex == 0x06) {
		QGRemoveMember(user, 0x01);
		return(0x00);
	}
	if (listindex == 0x07) {
		QGShowCandidates(user);
		return(0x00);
	}
	if ((QGRecalcLeader() == user) && (listindex == 0x08)) {
		QGShowGuildmaster(user);
		return(0x00);
	}
	if (((QGRecalcLeader() == user) && (listindex == 0x09)) || ((QGRecalcLeader() != user) && (listindex == 0x08))) {
		QGShowWarGump(user);
		return(0x00);
	}
	if (listindex == 0x08) {
		if (QGRecalcLeader() == user) {
			QGShowGuildmaster(user);
		} else {
			systemMessage(user, "Only the current guild leader may access guildmaster functions.");
			QGShowMain(user);
		}
		return(0x00);
	}
	QGShowMain(user);
	return(0x00);
}

trigger typeselected(0x71) {
	if (listindex == 0x00) {
		QGShowMain(user);
		return(0x01);
	}
	if (QGRecalcLeader() != user) {
		systemMessage(user, "Only the current guild leader may access guildmaster functions.");
		QGShowMain(user);
		return(0x00);
	}
	if (listindex == 0x01) {
		QGMenuUser = user;
		systemMessage(user, "Enter the new guild name.");
		textEntry(this, user, 0x85, 0x00, QGName());
		return(0x00);
	}
	if (listindex == 0x02) {
		QGMenuUser = user;
		systemMessage(user, "Enter a guild abbreviation of four characters or less. Enter none for no abbreviation.");
		textEntry(this, user, 0x80, 0x00, "");
		return(0x00);
	}
	if (listindex == 0x03) {
		QGMenuUser = user;
		systemMessage(user, "Enter the guild charter.");
		textEntry(this, user, 0x81, 0x00, "");
		return(0x00);
	}
	if (listindex == 0x04) {
		QGMenuUser = user;
		systemMessage(user, "Enter the guild website.");
		textEntry(this, user, 0x82, 0x00, QGWebsite());
		return(0x00);
	}
	if (listindex == 0x05) {
		QGShowMemberPicker(user, 0x02, 0x00, "Dismiss which member?");
		return(0x00);
	}
	if (listindex == 0x06) {
		systemMessage(user, "Guild warfare is not yet operational.");
		QGShowGuildmaster(user);
		return(0x00);
	}
	if (listindex == 0x07) {
		QGShowCandidatePicker(user, 0x04, 0x00, "Accept which candidate?");
		return(0x00);
	}
	if (listindex == 0x08) {
		QGShowCandidatePicker(user, 0x05, 0x00, "Refuse which candidate?");
		return(0x00);
	}
	if (listindex == 0x09) {
		QGMenuUser = user;
		systemMessage(user, "Enter the guildmaster title.");
		textEntry(this, user, 0x83, 0x00, QGMasterTitle());
		return(0x00);
	}
	if (listindex == 0x0A) {
		QGShowMemberPicker(user, 0x03, 0x00, "Grant title to whom?");
		return(0x00);
	}
	if (listindex == 0x0B) {
		QGShowMain(user);
		return(0x00);
	}
	QGShowGuildmaster(user);
	return(0x00);
}

trigger typeselected(0x72) {
	if (listindex == 0x00) {
		QGShowMain(user);
		return(0x01);
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	int totalPages = QGListPages(numInList(members));
	int page = QGMenuPage;
	if (page < 0x00) {
		page = 0x00;
	}
	if (page >= totalPages) {
		page = totalPages - 0x01;
	}
	int start = page * 0x14;
	int stop = start + 0x14;
	if (stop > numInList(members)) {
		stop = numInList(members);
	}
	int rowCount = stop - start;
	if (listindex <= rowCount) {
		QGShowMain(user);
		return(0x00);
	}
	int choice = listindex - rowCount;
	if (page > 0x00) {
		if (choice == 0x01) {
			QGShowRoster(user, page - 0x01);
			return(0x00);
		}
		choice--;
	}
	if ((page + 0x01) < totalPages) {
		if (choice == 0x01) {
			QGShowRoster(user, page + 0x01);
			return(0x00);
		}
		choice--;
	}
	QGShowMain(user);
	return(0x00);
}

trigger typeselected(0x73) {
	QGShowMain(user);
	return(0x00);
}

trigger typeselected(0x74) {
	if (listindex == 0x00) {
		if (QGMenuMode == 0x01) {
			QGShowMain(user);
		} else {
			QGShowGuildmaster(user);
		}
		return(0x01);
	}
	if (QGFindMember(user) < 0x00) {
		systemMessage(user, "You are not a member of this guild.");
		return(0x00);
	}
	list members;
	getObjListVar(members, this, "guildMembers");
	int totalPages = QGListPages(numInList(members));
	int page = QGMenuPage;
	if (page < 0x00) {
		page = 0x00;
	}
	if (page >= totalPages) {
		page = totalPages - 0x01;
	}
	int start = page * 0x14;
	int stop = start + 0x14;
	if (stop > numInList(members)) {
		stop = numInList(members);
	}
	int rowCount = stop - start;
	if (listindex > rowCount) {
		int choice = listindex - rowCount;
		if (page > 0x00) {
			if (choice == 0x01) {
				QGShowMemberPicker(user, QGMenuMode, page - 0x01, "Select member.");
				return(0x00);
			}
			choice--;
		}
		if ((page + 0x01) < totalPages) {
			if (choice == 0x01) {
				QGShowMemberPicker(user, QGMenuMode, page + 0x01, "Select member.");
				return(0x00);
			}
			choice--;
		}
		if (QGMenuMode == 0x01) {
			QGShowMain(user);
		} else {
			QGShowGuildmaster(user);
		}
		return(0x00);
	}
	int index = start + listindex - 0x01;
	obj guildMember = QGMemberObj(index);
	if (guildMember == NULL()) {
		QGShowMain(user);
		return(0x00);
	}
	if (QGMenuMode == 0x01) {
		QGSetFealty(user, guildMember);
		systemMessage(user, "You have declared your fealty.");
		QGShowMain(user);
		return(0x00);
	}
	if (QGMenuMode == 0x02) {
		if (QGRecalcLeader() != user) {
			systemMessage(user, "Only the current guild leader may dismiss members.");
			QGShowMain(user);
			return(0x00);
		}
		if (guildMember == user) {
			systemMessage(user, "You cannot dismiss yourself. Use resign instead.");
			QGShowGuildmaster(user);
			return(0x00);
		}
		QGRemoveMember(guildMember, 0x01);
		QGShowGuildmaster(user);
		return(0x00);
	}
	if (QGMenuMode == 0x03) {
		if (QGRecalcLeader() != user) {
			systemMessage(user, "Only the current guild leader may grant titles.");
			QGShowMain(user);
			return(0x00);
		}
		QGMenuTarget = guildMember;
		QGMenuUser = user;
		systemMessage(user, "Enter the title to grant. Enter none to remove the title.");
		textEntry(this, user, 0x84, 0x00, "");
		return(0x00);
	}
	QGShowMain(user);
	return(0x00);
}

trigger typeselected(0x75) {
	if (listindex == 0x00) {
		QGShowGuildmaster(user);
		return(0x01);
	}
	if (QGRecalcLeader() != user) {
		systemMessage(user, "Only the current guild leader may change candidate standing.");
		QGShowMain(user);
		return(0x00);
	}
	list candidates;
	getObjListVar(candidates, this, "guildCandidates");
	int totalPages = QGListPages(numInList(candidates));
	int page = QGMenuPage;
	if (page < 0x00) {
		page = 0x00;
	}
	if (page >= totalPages) {
		page = totalPages - 0x01;
	}
	int start = page * 0x14;
	int stop = start + 0x14;
	if (stop > numInList(candidates)) {
		stop = numInList(candidates);
	}
	int rowCount = stop - start;
	if (listindex > rowCount) {
		int choice = listindex - rowCount;
		if (page > 0x00) {
			if (choice == 0x01) {
				QGShowCandidatePicker(user, QGMenuMode, page - 0x01, "Select candidate.");
				return(0x00);
			}
			choice--;
		}
		if ((page + 0x01) < totalPages) {
			if (choice == 0x01) {
				QGShowCandidatePicker(user, QGMenuMode, page + 0x01, "Select candidate.");
				return(0x00);
			}
			choice--;
		}
		QGShowGuildmaster(user);
		return(0x00);
	}
	int index = start + listindex - 0x01;
	if (QGMenuMode == 0x04) {
		QGAcceptCandidate(user, index);
		return(0x00);
	}
	if (QGMenuMode == 0x05) {
		QGRefuseCandidate(user, index);
		return(0x00);
	}
	QGShowGuildmaster(user);
	return(0x00);
}

trigger typeselected(0x77) {
	if (listindex == 0x00) {
		QGShowMain(user);
		return(0x01);
	}
	if (QGFindMember(user) < 0x00) {
		systemMessage(user, "You are not a member of this guild.");
		return(0x00);
	}
	if (listindex == 0x01) {
		QGShowWarList(user, "We are at war with:");
		return(0x00);
	}
	if (listindex == 0x02) {
		QGShowWarList(user, "Guilds that we have declared war on: ");
		return(0x00);
	}
	if (listindex == 0x03) {
		QGShowWarList(user, "Guilds that have declared war on us:");
		return(0x00);
	}
	QGShowMain(user);
	return(0x00);
}

trigger typeselected(0x78) {
	if (QGFindMember(user) < 0x00) {
		systemMessage(user, "You are not a member of this guild.");
		return(0x00);
	}
	QGShowWarGump(user);
	return(0x00);
}

trigger targetobj {
	if (QGTargetMode == 0x01) {
		QGTargetMode = 0x00;
		QGRecruit(user, usedon);
		return(0x00);
	}
	return(0x01);
}

trigger textentry(0x80) {
	if (!button) {
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (!QGConfirmMaster(QGMenuUser)) {
		return(0x00);
	}
	if (isObscene(text)) {
		systemMessage(QGMenuUser, "That abbreviation is not permissible.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	QGPendingNoAbbr = 0x00;
	QGPendingAbbr = text;
	string requested = text;
	if ((text == "") || (text == "none")) {
		requested = QGName();
		QGPendingNoAbbr = 0x01;
	}
	if ((!QGPendingNoAbbr) && (strlen(text) > 0x04)) {
		systemMessage(QGMenuUser, "Guild abbreviations are limited to four characters.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (requested == QGAbbr()) {
		systemMessage(QGMenuUser, "That is already your guild abbreviation.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (!QGCanUseWeeklyChange(QGMenuUser, "lastGuildAbbrChangeSecs", "abbreviation")) {
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	list request = requested;
	multiMessageToLoc(QGMasterLoc, "requestChangeAbbr", request);
	return(0x00);
}

trigger textentry(0x81) {
	if (!button) {
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (!QGConfirmMaster(QGMenuUser)) {
		return(0x00);
	}
	if (isObscene(text)) {
		systemMessage(QGMenuUser, "That charter is not permissible.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (text == "") {
		setObjVar(this, "guildCharter", "No charter has been set.");
	} else {
		setObjVar(this, "guildCharter", text);
	}
	QGNotifyMembers("The guild charter has changed.");
	systemMessage(QGMenuUser, "Enter the guild website.");
	textEntry(this, QGMenuUser, 0x82, 0x00, QGWebsite());
	return(0x00);
}

trigger textentry(0x82) {
	if (!button) {
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (!QGConfirmMaster(QGMenuUser)) {
		return(0x00);
	}
	if (text == "") {
		setObjVar(this, "guildWebsite", "http://www.ultimaonline.com");
	} else {
		setObjVar(this, "guildWebsite", text);
	}
	QGNotifyMembers("The guild website has changed.");
	QGShowGuildmaster(QGMenuUser);
	return(0x00);
}

trigger textentry(0x83) {
	if (!button) {
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (!QGConfirmMaster(QGMenuUser)) {
		return(0x00);
	}
	if (isObscene(text)) {
		systemMessage(QGMenuUser, "That title is not permissible.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if ((text == "") || (text == "none")) {
		setObjVar(this, "guildmasterTitle", "Guildmaster");
	} else {
		setObjVar(this, "guildmasterTitle", text);
	}
	QGUpdateAll();
	QGNotifyMembers("The guildmaster title has changed.");
	QGShowGuildmaster(QGMenuUser);
	return(0x00);
}

trigger textentry(0x84) {
	if (!button) {
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (!QGConfirmMaster(QGMenuUser)) {
		return(0x00);
	}
	if (isObscene(text)) {
		systemMessage(QGMenuUser, "That title is not permissible.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	string title = text;
	if ((title == "") || (title == "none")) {
		title = " ";
	}
	QGSetTitle(QGMenuTarget, title);
	QGShowGuildmaster(QGMenuUser);
	return(0x00);
}

trigger textentry(0x85) {
	if (!button) {
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (!QGConfirmMaster(QGMenuUser)) {
		return(0x00);
	}
	if (text == "") {
		systemMessage(QGMenuUser, "Guild names may not be blank.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (isObscene(text)) {
		systemMessage(QGMenuUser, "That guild name is not permissible.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (text == QGName()) {
		systemMessage(QGMenuUser, "That is already your guild name.");
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	if (!QGCanUseWeeklyChange(QGMenuUser, "lastGuildNameChangeSecs", "name")) {
		QGShowGuildmaster(QGMenuUser);
		return(0x00);
	}
	QGPendingName = text;
	list request = text;
	multiMessageToLoc(QGMasterLoc, "requestChangeName", request);
	return(0x00);
}

trigger message("updateMyGuildInfo") {
	QGSendUpdate(sender);
	return(0x01);
}

trigger message("removeFromGuild") {
	if (QGFindMember(sender) >= 0x00) {
		QGRemoveMember(sender, 0x01);
		return(0x01);
	}
	if (numInList(args) > 0x00) {
		string name = args[0x00];
		int index = QGFindMemberByName(name);
		if (index >= 0x00) {
			obj guildMember = QGMemberObj(index);
			QGRemoveMember(guildMember, 0x01);
		}
	}
	return(0x01);
}

trigger message("canChangeName") {
	string name = args[0x00];
	setObjVar(this, "guildName", name);
	if (!hasObjVar(this, "hasGuildAbbreviation")) {
		setObjVar(this, "guildAbbreviation", name);
	}
	setObjVar(this, "lastGuildNameChangeSecs", getTimeSecs());
	QGEnsure();
	QGUpdateAll();
	QGNotifyMembers("The guild name has changed.");
	systemMessage(QGMenuUser, "Your guild name has been changed.");
	QGShowGuildmaster(QGMenuUser);
	return(0x01);
}

trigger message("cannotChangeName") {
	systemMessage(QGMenuUser, "There is already a guild using that name on this shard.");
	QGShowGuildmaster(QGMenuUser);
	return(0x01);
}

trigger message("canChangeAbbr") {
	string abbr = args[0x00];
	if (QGPendingNoAbbr) {
		removeObjVar(this, "hasGuildAbbreviation");
		setObjVar(this, "guildAbbreviation", QGName());
		systemMessage(QGMenuUser, "Your guild will now display its full name.");
	} else {
		setObjVar(this, "hasGuildAbbreviation", 0x01);
		setObjVar(this, "guildAbbreviation", abbr);
		systemMessage(QGMenuUser, "Your guild abbreviation has been changed.");
	}
	setObjVar(this, "lastGuildAbbrChangeSecs", getTimeSecs());
	QGRegister("IAmHere");
	QGUpdateAll();
	QGNotifyMembers("The guild abbreviation has changed.");
	QGShowGuildmaster(QGMenuUser);
	return(0x01);
}

trigger message("cannotChangeAbbr") {
	systemMessage(QGMenuUser, "There is already a guild using that abbreviation on this shard.");
	QGShowGuildmaster(QGMenuUser);
	return(0x01);
}

trigger message("updatedGuildList") {
	return(0x01);
}

trigger message("disbanded") {
	if (numInList(args) > 0x00) {
		obj deadGuild = args[0x00];
		if (deadGuild != this) {
			QGNotifyGlobal("Another guild has been disbanded.");
		}
	}
	return(0x01);
}
