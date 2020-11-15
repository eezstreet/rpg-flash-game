var tempEnts:Array = new Array();
var explodeArray:Array = new Array();
var maxTempEnts = 1024;
var maxTempEntLife = 3; //3 seconds

// create a temporary entity that is moving in a set direction
function CreateMissile(graphic:String, spellID:int) {
	if(tempEnts.length<maxTempEnts) {
				// Create and position a new bullet
		var newEnt:SpellShot = new SpellShot();
		var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
		newEnt.speed = 0.4;
		newEnt.dx = Math.sin(Math.PI*(hero.mc.rotation+90)/180);
		newEnt.dy = -Math.cos(Math.PI*(hero.mc.rotation+90)/180);
		newEnt.x = hero.mc.x;
		newEnt.y = hero.mc.y;
		newEnt.spellID = spellID;
		newEnt.timeStamp = getTimer();
		newEnt.name = "tempEnt" + tempEnts.length;
		newEnt.gotoAndPlay(graphic);
		lvl_mc.addChild(newEnt);
		tempEnts.push(newEnt);
		//tempEnts[tempEnts.length].gotoAndStop(graphic);
	}
}

// explode temporary entities with this function.
// THIS DOES NOT DEAL DAMAGE TO ENEMIES!
function explodeTempEnt(id:int, removeMe:DisplayObject){
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");

	if(!removeMe){
		return;
	}
	lvl_mc.removeChild(tempEnts[id]);

	tempEnts.splice(id,1);
}

function performExplode(id:int){
	var missile = tempEnts[id];
	var explode:exploder = new exploder();
	var ourFrame:String = missile.currentLabel;
	var spellID = tempEnts[id].spellID;
	//missile.gotoAndPlay(spellTable[id][0] + "Explode");
	if(!missile){
		trace("Attempted to performExplode on a tempEnt that doesn't exist!");
	}
	explode.x = missile.x;
	explode.y = missile.y;
	explode.name = "explode" + explodeArray.length;
	explode.gotoAndPlay(spellTable[tempEnts[id].spellID][0]);
	explode.timeStamp = getTimer();
	explodeTempEnt(id, tempEnts[id]);
	addChild(explode);
	explodeArray.push(explode);
	/*missile.dx = 0;
	missile.dy = 0;
	missile.identifier = id;*/
}

function clearThisCache(timeFrame:int){
	//Determines whether or not we need to remove explosions from the cache.
	for(var i:int = 0; i < explodeArray.length-1; i++){
		if(getTimer() >= explodeArray[i].timeStamp + 1000){
			//removeChild(getChildByName("explode" + i));
			explodeArray.splice(i, 1);
			return;
		}
	}
}
	
	

// Temporary entities are entities such as bullets, missiles, etc.
// This function tells our temporary entities to start moving.
function moveTempEnts(timeFrame:int):void{
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	for(var i:int=tempEnts.length-1; i >= 0; i--){ //fugly loop, but it does each action for each temp ent
		if(getTimer() >= tempEnts[i].timeStamp + (maxTempEntLife * 1000)){
			explodeTempEnt(i, tempEnts[i]);
			return;
		}
		tempEnts[i].x += (tempEnts[i].dx)*(tempEnts[i].speed)*(timeFrame);
		tempEnts[i].y += (tempEnts[i].dy)*(tempEnts[i].speed)*(timeFrame);
		//trace(game.tempEnts[i].x);
		
		var num_children:int = lvl_mc.numChildren;
		for(var j:int = 0; j < num_children; j++) {
			if(!num_children){
				break;
			}
			var mc = lvl_mc.getChildAt(j);
		
			// used to determine if we are hitting the mc
			var hit_mc:Boolean;
		
			if(mc.name.indexOf("collideBox") != -1) {
				hit_mc = hit_test(tempEnts[i], mc, true);
				if(hit_mc) {
					explodeTempEnt(i, tempEnts[i]);
					break;
				}
			}
			else if(mc.name.indexOf("xpc") != -1){
				hit_mc = hit_test(tempEnts[i], mc, true);
				if(hit_mc) {
					//explodeTempEnt(i, tempEnts[i]);
					performExplode(i);
					break;
				}
			}
			else if(mc.name.indexOf("npc") != -1){
				hit_mc = hit_test(tempEnts[i], mc, true);
				if(hit_mc) {
					//explodeTempEnt(i, tempEnts[i]);
					performExplode(i);
					break;
				}
			}
			else if(mc.name.indexOf("monster") != -1){
				hit_mc = hit_test(tempEnts[i], mc, true);
				if(hit_mc) {
					//tempEntExplode(i, tempEnts[i]);
					//BugFix2: The temp ent entity is destroyed upon explosion, so subtract health first.
					deductMonsterHP(mc, dealDamage(mc, hero, spellTable[tempEnts[i].spellID][12], calculateFinalDamage(tempEnts[i].spellID)));
					//explodeTempEnt(i, tempEnts[i]);
					mc.inPain = true;
					mc.painTime = 100;
					performExplode(i);
					break;
				}
			}
		}
	}
}