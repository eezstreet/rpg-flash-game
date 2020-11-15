include "idle.as";
include "warrior.as";
include "wildlife.as";

var MODE_SCAN = 0;
var MODE_SCAN_BACK = 1;
var MODE_THINK = 2;
var MODE_CHASE = 3;
var MODE_ATTACK = 4;
var MODE_PATROL = 5;

function doAI(monster:MovieClip):void{
	if(monster.health <= 0){
		return;
	}
	if(monster.aiType == "Idle"){
		doIdleAI();
	} else if(monster.aiType == "Warrior"){
		doWarriorAI(monster);
	} else if(monster.aiType == "Wildlife"){
		doWildlifeAI(monster);
	}
}

function monsterAttack(monster:MovieClip, victim:Object):void{
	var monIndex = monster.pointer;
	monster.graphic.gotoAndPlay(monsterTable[monIndex][2] + "-A" + Q_irand(1,3));
	//Bug fixed: can attack other things
	victim.stats.health -= dealDamage(victim, monster, "Melee", Number(Q_irand(monsterTable[monIndex][6], monsterTable[monIndex][7])));
	game.mc.getChildByName("ingamemenu").nextFrame();
}

function initPatrolPoints(monster:MovieClip){
	//monsterArray[monster.num] = new Array();
	/*var values:Array = new Array();
	if(!monsterPPArray){
		return;
	}
	for(var i:int = 0; i < monster.numChildren; i++){
		var mc = monster.getChildAt(i);
		if(mc.name.indexOf("graphic") != -1){
			continue; //You're not a PatrolPoint, gtfo.
		}
		else if(mc.name.indexOf("pp") != -1){
			mc.alpha = 0; //PPs are hidden outside of the editor
			values = mc.name.split("_");
			var num:int = values[1];
			mc.sort = num;
			monster.removeChild(mc);
			monsterPPArray[monster.num].push(mc);
			monsterPPArray[monster.num].sort();
		}
	}
	monster.ppcurrent = 0; //We go to the first one first, however we cannot return
	//to this position that we are in now, ever.*/
}

function patrolArea(monster:MovieClip):void{
	//Patrol the area.
	var pp = monster.ppcurrent; //pp = PatrolPoint(); //Is this a pointer? -rww
	if(inRadiusOf(monster, monsterPPArray[monster.num][pp+1], 30)){
		pp++;
	} else if(!monsterPPArray[monster.num][pp]){
		pp = 0; //if this isn't a pointer, we're in for trouble...
	} else{
		if(monsterPPArray[monster.num][pp+1].x >= monster.x){
			monster.x--;
		} else if(monsterPPArray[monster.num][pp+1].x <= monster.x){
			monster.x++;
		} if(monsterPPArray[monster.num][pp+1].y >= monster.y){
			monster.y--;
		} else if(monsterPPArray[monster.num][pp+1].y <= monster.y){
			monster.y++;
		}
	}
}