var nextHack:String = "Basic Shot";
var stringHack:String = "Basic Shot (Rank 1)";

//define spell table
var spellTable:Array = new Array();
hero.learnedSpells = new Array();
spellTable[0] = new Array();
spellTable[1] = new Array();
var MAX_SPELLS = 2; //Last spell ID + 1

hero.coolDownTable = new Array();

// switch spells
function nextSpell():void{
	if(!hero.numberOfLearnedSpells){
		trace("No spells known.");
		return;
	}
	else{
		while( hero.spellSel >= hero.numberOfLearnedSpells ){
			hero.spellSel = (hero.numberOfLearnedSpells - 1);
		}
		if( hero.spellSel == (hero.numberOfLearnedSpells - 1) ){
			hero.spellSel = 0;
			hero.currentSpell = hero.learnedSpells[0];
		}
		else{
			hero.spellSel++;
			hero.currentSpell = hero.learnedSpells[hero.spellSel];
		}
	}
	nextHack = spellTable[hero.currentSpell][0];
	stringHack = spellTable[hero.currentSpell][0] + " (" + spellTable[hero.currentSpell][1] + ")";
	game.mc.getChildByName("ingamemenu").nextFrame();
	game.mc.getChildByName("ingamemenu").spellIcon.gotoAndPlay("switchme");
}
function prevSpell():void{
	if(!hero.numberOfLearnedSpells){
		trace("No spells known.");
		return;
	}
	else{
		while( hero.spellSel >= hero.numberOfLearnedSpells ){
			hero.spellSel = 0;
		}
		if( hero.spellSel == 0 ){
			hero.spellSel = (hero.numberOfLearnedSpells - 1);
			hero.currentSpell = hero.learnedSpells[hero.spellSel];
		}
		else{
			hero.spellSel--;
			hero.currentSpell = hero.learnedSpells[hero.spellSel];
		}
	}
	nextHack = spellTable[hero.currentSpell][0];
	stringHack = spellTable[hero.currentSpell][0] + " (" + spellTable[hero.currentSpell][1] + ")";
	game.mc.getChildByName("ingamemenu").nextFrame();
	game.mc.getChildByName("ingamemenu").spellIcon.gotoAndPlay("switchme");
}

//sort learned spells
function tabulateSpells():void{
	hero.learnedSpells.sort();
}

//unlearn spell
function unLearnSpell(spellID:int, silent:Boolean = false):void{
	var i;
	var weBroke:Boolean = false;
	for(i = 0; i < MAX_SPELLS; i++){
		if(hero.learnedSpells[i] == spellID){
			hero.learnedSpells[i] = -1;
			weBroke = true;
			break;
		}
		else{
			continue;
		}
	}
	if(!weBroke){
		//trace("Attempted to unlearn " + spellTable[spellID][0] + ", but we haven't learned it!");
		return;
	}
	else if(hero.currentSpell == spellID){
		nextSpell();
	}
	if(!silent){
		trace("You have unlearned " + spellTable[spellID][0] + " (" + spellTable[spellID][1] + ").");
	}
	tabulateSpells();
	hero.numberOfLearnedSpells--;
}
			
			
//learn spell
function learnSpell(spellID:int, silent:Boolean = false):void{
	var i;
	var j;
	var weBroke:Boolean = false;
	for(i = 0; i < MAX_SPELLS; i++){ //First loop - determine if the spell is already known
		if(spellID == hero.learnedSpells[i]){
			trace("Spell " + spellTable[spellID][0] + " is already known.");
			return;
		}
	}
	for(i = 0; i < MAX_SPELLS; i++){ //Second loop - remove spells with the same rankgroup
		if(hero.learnedSpells[i]){
			for(j = 0; j < MAX_SPELLS; j++){
				if(spellTable[j][11] == spellTable[spellID][11]){
					unLearnSpell(j);
					weBroke = true;
					break;
				}
			}
		}
	}
	for(i = 0; i < MAX_SPELLS; i++){ //Third loop - learn the spell
		if(hero.learnedSpells[i] > -1){
			continue; //current slot is occupied
		}
		else{ //empty slot
			hero.learnedSpells[i] = spellID;
			break;
		}
	}
					
			
	if(!silent){
		trace("You have learned " + spellTable[spellID][0] + " (" + spellTable[spellID][1] + ").");
	}
	tabulateSpells();
	hero.numberOfLearnedSpells++;
}
	
// init spells
function initSpells():void{
	var i;
	hero.currentSpell = 0;
	hero.spellSel = 0;
	hero.numberOfLearnedSpells = 0;
	//hero.currentSpell is a pointer to the array, which holds all of our data.
	//Every time we learn a new spell, all spells with the same rank grouping
	//are removed, so we can't cycle between spells of different rank.
	
	//Likewise, when we learn a new spell, our spellbook is organized so low ID
	//spells are at the beginning, and high ID spells are at the end. Not very
	//ergonomic, but it works.
	for(i = 0; i < MAX_SPELLS; i++){ //first loop - set all to empty
		hero.learnedSpells[i] = -1;
		hero.coolDownTable[i] = 0;
	}
		
	for(i = 0; i < MAX_SPELLS; i++){ //second loop - learn initial spells
		if(spellTable[i][10] == true){
			learnSpell(i, true);
			continue;
		}
		else{
			continue;
		}
	}
}

// perform spell
function castSpell():void{
	if(hero.coolDownTable[hero.currentSpell] > 0){
		return; //can't cast if in cooldown mode
	}
	switch(spellTable[hero.currentSpell][8]){
		case 0:
			CreateMissile("BasicShot", 0);
			break;
		case 1:
			CreateMissile("SlowShot", 1);
			break;
	}
	hero.coolDownTable[hero.currentSpell] += spellTable[hero.currentSpell][7];
}