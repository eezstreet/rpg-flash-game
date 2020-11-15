var karmaTable:Array = new Array();
karmaTable[0] = new Array(); //very evil karma
karmaTable[1] = new Array(); //evil karma
karmaTable[2] = new Array(); //neutral karma
karmaTable[3] = new Array(); //good karma
karmaTable[4] = new Array(); //very good karma
//Karma is figured like this--> Our Karma is neutral at start.
//Now, when we do something that is evil, such as stealing,
//murdering, etc, our Karma goes down. If we do something good,
//our Karma goes up.

//Quests can have a Karma requirement, and your level title is
//figured with Karma as well.
karmaTable[0][0] = null;
karmaTable[1][0] = null;
karmaTable[2][0] = null;
karmaTable[3][0] = null;
karmaTable[4][0] = null;

karmaTable[0][1] = "Murderer";
karmaTable[1][1] = "Crook";
karmaTable[2][1] = "Noob";
karmaTable[3][1] = "Goody Two-Shoes";
karmaTable[4][1] = "Follower of the Light";

karmaTable[0][2] = "Pint Sized Slasher";
karmaTable[1][2] = "Thief";
karmaTable[2][2] = "Amateur";
karmaTable[3][2] = "Good Samaritan";
karmaTable[4][2] = "Faithful";

function allocateStatPoint(stat:String){
	if(hero.statPoints <= 0){
		//No stat points. You freaking cheater.
		return;
	}
	hero.statPoints--;
	if(stat == "Strength"){
		hero.stats.strengthStat++;
	} else if(stat == "Dexterity"){
		hero.stats.dexterityStat++;
		hero.stats.attPower += hero.levelUp.statUp.attPowerPerDex;
		hero.stats.dodge += hero.levelUp.statUp.dodgePerDex;
		//fix: Don't be gay. Round off the dodge rating.
	} else if(stat == "Intellect"){
		hero.stats.intellectStat++;
		hero.stats.spellPower += hero.levelUp.statUp.spellPowerPerInt;
		hero.stats.rangedPower += hero.levelUp.statUp.rangePowerPerInt;
		hero.stats.maxMana += hero.levelUp.statUp.mpPerInt;
		hero.stats.mana += hero.levelUp.statUp.mpPerInt;
	} else if(stat == "Constitution"){
		hero.stats.conStat++;
		hero.stats.health += hero.levelUp.statUp.hpPerCon;
		hero.stats.maxHealth += hero.levelUp.statUp.hpPerCon;
		hero.stats.mana += hero.levelUp.statUp.mpPerCon;
		hero.stats.maxMana += hero.levelUp.statUp.mpPerCon;
	} else if(stat == "Stamina"){
		hero.stats.staminaStat++;
		hero.stats.hpGenRate += hero.levelUp.statUp.hpGenRatePerSta;
		hero.stats.mpGenRate += hero.levelUp.statUp.mpGenRatePerSta;
	} else{
		hero.stats.strengthStat++;
	}
	game.mc.getChildByName("ingamemenu").nextFrame();
}
	

function initExperience(){
	hero.stats = new Object();
	
	//Starting Stats!
	hero.stats.strengthStat = 4;
	hero.stats.dexterityStat = 3;
	hero.stats.intellectStat = 4;
	hero.stats.conStat = 4;
	hero.stats.staminaStat = 5;
	
	hero.stats.attPower = 0; //raw points
	hero.stats.dodge = 1.0; //raw percent
	hero.stats.spellPower = 0; //raw points
	hero.stats.rangedPower = 0; //raw points
	hero.stats.hpGenRate = 10; //full ratio percent
	hero.stats.mpGenRate = 50; //full ratio percent
	hero.stats.defense = 0; //raw points
	
	//Initial Karma Settings
	hero.karma = new Object();
	hero.karma.karmaLevel = 2; //neutral
	hero.karma.totalKarma = 0; //No karma.
	
	//Initial Health Settings
	hero.stats.maxHealth = 20;
	hero.stats.health = hero.stats.maxHealth;
	hero.stats.maxMana = 5;
	hero.stats.mana = hero.stats.maxMana;
	
	//Initial resistances
	hero.stats.resistances = new Object();
	hero.stats.resistances.fire = 0;
	hero.stats.resistances.frost = 0;
	hero.stats.resistances.holy = 0;
	hero.stats.resistances.nature = 0;
	hero.stats.resistances.shadow = 0;
	
	//Stat increases per level up
	hero.levelUp = new Object();
	hero.levelUp.ptsPerLevel = 5;
	hero.levelUp.hpPerLevel = 10;
	hero.levelUp.mpPerLevel = 5;
	hero.levelUp.strPerLevel = 1;
	hero.levelUp.dexPerLevel = 0;
	hero.levelUp.intPerLevel = 1;
	hero.levelUp.conPerLevel = 0;
	hero.levelUp.staPerLevel = 1;
	
	//Stat increases per stat allocation
	hero.levelUp.statUp = new Object();
	hero.levelUp.statUp.attPowerPerDex = 2; 	//Dexterity - Attack Power
	hero.levelUp.statUp.dodgePerDex = 0.1;		//Dexterity - Dodge Chance (percent)
	hero.levelUp.statUp.spellPowerPerInt = 2;	//Intellect - Spell Power
	hero.levelUp.statUp.rangePowerPerInt = 2;	//Intellect - Ranged Power
	hero.levelUp.statUp.mpPerInt = 4;			//Intellect - Max Mana
	hero.levelUp.statUp.hpPerCon = 3;			//Constitution - Max HP
	hero.levelUp.statUp.mpPerCon = 1;			//Constitution - Max Mana
	hero.levelUp.statUp.hpGenRatePerSta = 30;	//Stamina - Health Regeneration Rate
	hero.levelUp.statUp.mpGenRatePerSta = 40;	//Stamina - Mana Regeneration Rate
	
	hero.clevel = 1;
	hero.experience = 0;
	hero.expToNext = experienceTable[1];
	hero.statPoints = 15;
	game.mc.getChildByName("ingamemenu").xpFill.width = 1;
}

function cureAll(){
	//cureAll() removes all curses, poisons, and refills health and mana
	hero.stats.health 	= hero.stats.maxHealth;
	hero.stats.mana		= hero.stats.maxMana;
	trace("Your health and mana have been refilled.");
}

function addLevelUpStats(){
	hero.stats.maxHealth += hero.levelUp.hpPerLevel;
	hero.stats.maxMana += hero.levelUp.mpPerLevel;
	
	hero.stats.strengthStat += hero.levelUp.strPerLevel;
	hero.stats.dexterityStat += hero.levelUp.dexPerLevel;
	hero.stats.intellectStat += hero.levelUp.intPerLevel;
	hero.stats.conStat += hero.levelUp.conPerLevel;
	hero.stats.staminaStat += hero.levelUp.staPerLevel;
	
	trace("Max Health increased by " + hero.levelUp.hpPerLevel);
	trace("Max Mana increased by " + hero.levelUp.mpPerLevel);
	if(hero.levelUp.strPerLevel){
		trace("Strength increased by " + hero.levelUp.strPerLevel);
	}
	if(hero.levelUp.dexPerLevel){
		trace("Dexterity increased by " + hero.levelUp.dexPerLevel);
	}
	if(hero.levelUp.intPerLevel){
		trace("Intellect increased by " + hero.levelUp.intPerLevel);
	}
	if(hero.levelUp.conPerLevel){
		trace("Constitution increased by " + hero.levelUp.conPerLevel);
	}
	if(hero.levelUp.staPerLevel){
		trace("Stamina increased by " + hero.levelUp.staPerLevel);
	}
}

function levelUp(){
	hero.experience -= hero.expToNext;
	hero.clevel++;
	hero.statPoints += hero.levelUp.ptsPerLevel;
	hero.expToNext = experienceTable[hero.clevel];
	addLevelUpStats();
	cureAll();
	trace("You have levelled up to level " + hero.clevel);
	game.mc.getChildByName("ingamemenu").hpBarFill.width = 200;
	game.mc.getChildByName("ingamemenu").nextFrame();
	//checkForLevelUp();
}

function checkForLevelUp(){
	var lvlPct = (hero.experience/hero.expToNext) * 100;
	if(hero.experience >= hero.expToNext){
		levelUp();
	}
	game.mc.getChildByName("ingamemenu").xpFill.width = lvlPct * 2;
	game.mc.getChildByName("ingamemenu").nextFrame();
}

function addExperience(amount:int){
	hero.experience += amount;
	checkForLevelUp();
}