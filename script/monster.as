var NUM_MONSTERS = 0;
var monsterToolTipArray:Array = new Array();
var monsterArray:Array = new Array();
var monsterPPArray:Array = new Array();

function addHealthBar(e:Event){
	var health = e.currentTarget.health;
	var healthPct = (e.currentTarget.stats.health/monsterTable[e.currentTarget.pointer][1]) * 100;
	var healthBar:hpBar = new hpBar();
	var hpFill = healthBar.hpFill;
	var hpGraphic = hpFill.graphic;
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	
	healthBar.name = "hpbar" + e.currentTarget.num;
	healthBar.x = (MovieClip(e.currentTarget.graphic).x+16)+MovieClip(e.currentTarget).x+lvl_mc.x;
	healthBar.y = (MovieClip(e.currentTarget.graphic).y-20)+MovieClip(e.currentTarget).y+lvl_mc.y;
	healthBar.hpFill.width = (healthPct/2+1);
	if(healthPct){
		if(healthPct >= 87.5){
			healthBar.hpFill.graphic.gotoAndStop("dgreen");
		}
		else if(healthPct >= 75){
			healthBar.hpFill.graphic.gotoAndStop("lgreen");
		}
		else if(healthPct >= 62.5){
			healthBar.hpFill.graphic.gotoAndStop("lime");
		}
		else if(healthPct >= 50){
			healthBar.hpFill.graphic.gotoAndStop("yellow");
		}
		else if(healthPct >= 37.5){
			healthBar.hpFill.graphic.gotoAndStop("orange");
		}
		else if(healthPct >= 25){
			healthBar.hpFill.graphic.gotoAndStop("red");
		}
		else if(healthPct >= 12.5){
			healthBar.hpFill.graphic.gotoAndStop("dred");
		}
		else{
			healthBar.hpFill.graphic.gotoAndStop("black");
		}
	}
	if(getChildByName("hpbar" + e.currentTarget.num)){ //If we have a health bar, get rid of it temporarily
		removeChild(getChildByName("hpbar" + e.currentTarget.num));
	}
	addChild(healthBar);
	//setChildIndex(healthBar, );
	//setChildIndex(healthBar, getChildIndex(e.currentTarget)+1);
}

function killMonster(m:MovieClip){
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	var num = m.num;
	//var mCorpse:Corpse = new Corpse();
	//mCorpse.x = m.x;
	//mCorpse.y = m.y;
	//mCorpse.pointer = m.pointer;
	addExperience(m.expYield);
	monsterArray.splice(m, 1);
	lvl_mc.removeChild(m);
	m.removeEventListener(Event.ENTER_FRAME, addHealthBar);
	m.removeEventListener(Event.ENTER_FRAME, function(e:Event){
		doAI(MovieClip(e.currentTarget));
															  });
	removeChild(getChildByName("hpbar" + num));
	//lvl_mc.addChild(mCorpse);
}
	

//Create a new monster based on what's given. VERY NASTY FUNCTION! NEEDS CLEANING UP!
function createNewMonster(reference:MovieClip){
	var ref = reference;
 	var monster:MovieClip = ref;
	
	var mToolTipText:String;
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	var values:Array = reference.name.split("_");
	
	var index:int = values[1];
	var monsterStats:Array = monsterTable[index];
	if(!reference || !monster){
		//GTFO.
		return;
	}
	
	//Now, to mimic hero stuff.
	monster.stats = new Object();
	//Just zero for now, I guess. Really haven't got the time to make new monstats entries for these
	monster.stats.attPower = 0;
	monster.stats.dodge = 1.0; //Dodge is ALWAYS, ALWAYS 1 for monsters, unless adjusted by a stat
	monster.stats.spellPower = 0;
	monster.stats.rangedPower = 0;
	monster.stats.defense = 0;
	
	monster.stats.resistances = new Object();
	monster.stats.resistances.fire = monsterStats[8];
	monster.stats.resistances.frost = monsterStats[9];
	monster.stats.resistances.holy = monsterStats[10];
	monster.stats.resistances.nature = monsterStats[11];
	monster.stats.resistances.shadow = monsterStats[12];
	
	monster.stats.health = monsterStats[1];
	monster.gotoAndStop(monsterStats[2]);
	monster.x = reference.x;
	monster.y = reference.y;
	monster.width = reference.width;
	monster.height = reference.height;
	monster.stringName = monsterStats[0];
	monster.num = NUM_MONSTERS;
	//monster.name = "tempEnt_monster";
	monster.goAhead = true;
	//monster.name = "m" + monster.num;
	monster.additionalInfo = monsterStats[3];
	monster.expYield = monsterStats[4];
	monster.pointer = index;
	monster.aiType = monsterStats[5];
	monster.thinkTime = 0;
	monster.attackDelay = 0;
	monster.painTime = 0;
	monster.inPain = false;
	monster.rotationOffset = 45;
	monster.ppcurrent = 1;
	monsterPPArray[monster.num] = new Array();
	initPatrolPoints(monster);
	monster.addEventListener(Event.ENTER_FRAME, function(e:Event){
		doAI(MovieClip(e.currentTarget));
																 });
	//Somehow we need to change the name of this.
	//However, flash is exploding because we're
	//changing the name of a timeline object.
	//It's a pointer, see?
	
	
	monster.mToolTipText = "" + monsterStats[0] + "\n" + "Health: " + monster.stats.health + "\n" + monster.additionalInfo;
	monster.addEventListener(MouseEvent.MOUSE_OVER, mToolTip);
	monster.addEventListener(MouseEvent.MOUSE_OUT, rmToolTip);
	monster.addEventListener(Event.ENTER_FRAME, addHealthBar);
	
	
	

	lvl_mc.removeChild(reference);
	//monster.name = "tempEnt_monster";
	lvl_mc.addChildAt(monster, (hero.mc.index-1));
	monsterArray.push(monster);
	NUM_MONSTERS++;
	//monster.goAhead = true;
	
}

//reload data for the tooltips
function mToolTipReload(){
}

function deductMonsterHP(monster:MovieClip, amount){
	monster.stats.health -= amount;
	if(monster.stats.health <= 0){
		killMonster(monster);
	}
}