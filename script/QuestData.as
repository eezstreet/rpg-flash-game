var questNameHack:String;//hack: "Quest Added" string
var NUM_QUESTS:int = 3;
var MAX_OBJECTIVES:int = 10;
var questData:Object = new Object();
questData.questStates = new Array();
questData.questNames = new Array();
questData.questObjectiveStrings = new Array();
questData.questsActive = new Array();
questData.questLvlReq = new Array();
questData.questKarmaReq = new Array();

function getQuestNumFromString(quest:String):int {
	var i;
	for (i = 0; i < NUM_QUESTS; i++) {
		if (questData.questNames[i] == quest) {
			return i;
		} else {
			continue;
		}
	}
	trace("getQuestNumFromString: Bad argument: ''" + quest + " ''");
	return -1;
}

function initQuestData():void {
	var i;
	var j;

	for (i = 0; i < NUM_QUESTS; i++) {
		questData.questObjectiveStrings[i] = new Array();
	}
	for (i = 0; i < 10; i++) {
		questData.questsActive[i] = -1;
	}
	questData.questStates[0] = -1;//"Murder in Squareville"
	questData.questStates[1] = -1;//"Blood Feud"
	questData.questStates[2] = -1;//"Warren's Stutter"

	questData.questNames[0] = "Murder in Squareville";
	questData.questNames[1] = "Blood Feud";
	questData.questNames[2] = "Warren's Stutter";
	
	questData.questLvlReq[0] = 0;
	questData.questLvlReq[1] = 0;
	questData.questLvlReq[2] = 0;
	
	questData.questKarmaReq[0] = "Neutral or better";
	questData.questKarmaReq[1] = "None";
	questData.questKarmaReq[2] = "None";

	questData.questObjectiveStrings[0][0] = "Acquire a fingerprint kit.";
	questData.questObjectiveStrings[0][1] = "Speak to the Chief about the murders.";
	questData.questObjectiveStrings[0][2] = "Find out who murdered Carl Junebug";
	questData.questObjectiveStrings[0][3] = "Speak to the Chief for your reward -OR- interrogate Johnson";
	questData.questObjectiveStrings[0][4] = "Speak to the Chief for your reward.";
	questData.questObjectiveStrings[0][5] = "EOL";

	questData.questObjectiveStrings[1][0] = "Speak to the Mayor of Squareville about the feud";
	questData.questObjectiveStrings[1][1] = "Speak to the Mayor of Boldenvale about the feud";
	questData.questObjectiveStrings[1][2] = "Find a way to bring peace between the cities.";
	questData.questObjectiveStrings[1][3] = "Speak to the Mayor of Squareville for your reward.";
	questData.questObjectiveStrings[1][4] = "EOL";

	questData.questObjectiveStrings[2][0] = "Figure out why Warren stutters.";
	questData.questObjectiveStrings[2][1] = "Go to the Alchemist in Boldenvale for a cure.";
	questData.questObjectiveStrings[2][2] = "Acquire a Root of Oak and a Wolverine's Heart.";
	questData.questObjectiveStrings[2][3] = "Return to the Alchemist in Boldenvale";
	questData.questObjectiveStrings[2][4] = "Bring the cure to Deputy Warren for your reward.";
	questData.questObjectiveStrings[2][5] = "EOL";
}

function meetReqForQuest(questNum:int):Boolean{
	var i;
	var karma = hero.karma.karmaLevel;
	if(hero.clevel >= questData.questLvlReq[questNum]){
		if(questData.questKarmaReq[questNum] == "None"){
			return true;
		} else if(questData.questKarmaReq[questNum] == "Very Evil or better"){
			//if(karma >= 0){
				return true;
			//}
		} else if(questData.questKarmaReq[questNum] == "Very Evil"){
			if(karma == 0){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Evil or better"){
			if(karma >= 1){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Evil"){
			if(karma == 1){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Evil or worse"){
			if(karma <= 1){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Neutral"){
			if(karma == 2){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Neutral or better"){
			if(karma >= 2){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Neutral or worse"){
			if(karma <= 2){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Good"){
			if(karma == 3){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Good or better"){
			if(karma >= 3){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Good or worse"){
			if(karma <= 3){
				return true;
			}
		} else if(questData.questKarmaReq[questNum] == "Very Good"){
			if(karma == 4){
				return true;
			}
		}
	}
	return false;
}
		

function startQuest(questNum:int):void {
	var i;
	var notFull:Boolean = false;
	var currentlyActive:Boolean = false;
	for (i = 0; i < 9; i++) {
		if (questData.questsActive[i] == -1) {
			questData.questsActive[i] = questNum;
			notFull = true;
			break;
		} else if (questData.questsActive[i] == questNum) {
			currentlyActive = true;
			break;
		} else {
			continue;
		}
	}
	if (currentlyActive) {
		trace("Quest with ID "+ questNum + " is currently active. Ignoring...");
		return;
	} else if (!notFull) {//This is one hell of a double negative -- "if not not full"
		trace("Unable to start quest with ID:" + questNum + " Reason: Quest Log Full.");
		return;
	}
	questData.questStates[questNum] = 0;
	questNameHack = questData.questNames[questNum];
	game.mc.getChildByName("ingamemenu").questString.gotoAndPlay("" + questNameHack);
}

function advanceInQuest(questNum:int):void {
	questData.questStates[questNum]++;
	questNameHack = questData.questNames[questNum];
	game.mc.getChildByName("ingamemenu").questUpdate.gotoAndPlay("" + questNameHack);
}

function abandonQuest(questNum:int) {
	var i;
	var weBroke:Boolean = false;
	for (i = 0; i < 9; i++) {
		if (questData.questsActive[i] == questNum) {
			weBroke = true;
			questData.questsActive[i] = -1;
			break;
		} else {
			continue;
		}
	}
	if (!weBroke) {
		trace("Attempted to abandon a quest that we don't even have! WTF!");
	} else {
		questData.questStates[questNum] = -1;
		game.mc.getChildByName("ingamemenu").nextFrame();
	}
}