//include "tables/npcTable.as";
var absoluteLevelName:String = "Clovervale";

var levelWidth:int = 920;
var levelHeight:int = 680;

// transition between levels, seamlessly of course.
function transitionBetweenLevels(index:MovieClip):void{
	//absoluteLevelName = index.levelName;
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	//game.lvl.gotoAndStop(lvlnum);
	lvl_mc.x += index.XAdd;
	lvl_mc.y += index.YAdd;
	game.mc.getChildByName("ingamemenu").nextFrame();
	//The game map is actually one big grid, and we load different levels like that.
	//This actually decreases game load, as we don't need to save enemies/items in memory.
	hero.mc.x += index.heroXAdd;
	hero.mc.y += index.heroYAdd;
	hero.mc.x -= index.heroXSub;
	hero.mc.y -= index.heroYSub;
}

// set the level items in the level that was attached, passing the level movie clip
function set_level_items(lvl_mc:MovieClip):void {
	
	// get the number of children in the level
	var num_children:int = lvl_mc.numChildren;
	for(var i:int = 0; i < num_children; i++) {
		var values:Array;
		var props:Array = new Array();
		// holder of movieclips
		var mc = lvl_mc.getChildAt(i);
		
		// if the movieclip has the name "item" in it, then it must be
		if(mc.name.indexOf("item") != -1) {
			
			// split it so we get get in return, 'item', '*item name*', '*item quanity*'
			values = mc.name.split("_");
			props[0] = itemTable[0][values[1]];
			props[1] = itemTable[1][values[1]];
			props[2] = itemTable[2][values[1]];
			props[3] = itemTable[3][values[1]];
			props[4] = itemTable[4][values[1]];
			props[5] = values[1];
			
			// we just want to tell it to stop on that item name
			mc.gotoAndStop(props[0]);
			//Set the values for the item.
			mc.itemID = values[1];
			
			mc.toolTipText = props[0];
			mc.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			mc.addEventListener(MouseEvent.MOUSE_OUT, toolTipRemove);
			mc.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMove);
		}
		else if(mc.name.indexOf("level") != -1){
			
			mc.addEventListener(MouseEvent.MOUSE_OVER, ltoolTip);
			mc.addEventListener(MouseEvent.MOUSE_OUT, toolTipRemove);
			mc.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMove);
		}
		else if(mc.name.indexOf("ferry") != -1){
			mc.toolTipText = "Transporter";
			mc.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			mc.addEventListener(MouseEvent.MOUSE_OUT, toolTipRemove);
			mc.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMove);
		}
		else if(mc.name.indexOf("monster") != -1){
 			if(!mc.goAhead){
				createNewMonster(mc);
			}
		}
		else if(mc.name.indexOf("hex") != -1){
			values = mc.name.split("_");
			if(values[1] < 5){
				mc.gotoAndStop("1Hex");
			}
			else{
				mc.gotoAndStop("5Hex");
			}
			
			mc.toolTipText = values[1] + " Hex";
			mc.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			mc.addEventListener(MouseEvent.MOUSE_OUT, toolTipRemove);
			mc.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMove);
		}
		else if(mc.name.indexOf("npc") != -1){
			values = mc.name.split("_");
			mc.graphic.gotoAndStop("npc-"+ values[1]);
			if(values[3] == true){
				NUM_VENDORS++;
				values[3] = NUM_VENDORS;
			}
			mc.toolTipText = npcTable[values[4]];
			mc.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			mc.addEventListener(MouseEvent.MOUSE_OUT, toolTipRemove);
			mc.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMove);
			
		}
		else if(mc.name.indexOf("rpc") != -1){
			values = mc.name.split("_");
			mc.graphic.gotoAndStop("npc-"+ values[1]);
			mc.toolTipText = npcTable[values[4]];
			mc.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			mc.addEventListener(MouseEvent.MOUSE_OUT, toolTipRemove);
			mc.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMove);
			
		}
		else if(mc.name.indexOf("xpc") != -1){
			values = mc.name.split("_");
			mc.graphic.gotoAndStop("npc-"+ values[1]);
		}
		else if(mc.name.indexOf("ntrigger") != -1){
			mc.alpha = 0;
		} else if(mc.name.indexOf("loadZone") != -1){
			values = mc.name.split("_");
			mc.nextZone = values[1];
		}
		
	}
	
}

function nextLevelZone(levelZone:MovieClip){
	
	game.mc.removeChild(getChildByName("gamelevel"));
}
	

function createLevelTransition(coordX:int, coordY:int, lvlW:int, lvlH:int,
							   lvlAddX:int, lvlAddY:int, 
							   heroAddX:int, heroAddY:int,
							   heroSubX:int, heroSubY:int,
							   lvlName:String){
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	var newTransition:LevelTransition = new LevelTransition();
	
	// transition coordinates
	newTransition.x = coordX;
	newTransition.y = coordY;
	// level width and height
	newTransition.levelWidth 		= lvlW;
	newTransition.levelHeight 		= lvlH;
	// coordinate addition/subtraction upon transition
	newTransition.XAdd 				= lvlAddX;
	newTransition.YAdd				= lvlAddY;
	newTransition.heroXAdd			= heroAddX;
	newTransition.heroYAdd			= heroAddY;
	newTransition.heroXSub			= heroSubX;
	newTransition.heroYSub			= heroSubY;
	// tooltip/zone
	newTransition.levelName			= lvlName;
	
	newTransition.addEventListener(MouseEvent.MOUSE_OVER, ltoolTip);
	newTransition.addEventListener(MouseEvent.MOUSE_OUT, toolTipRemove);
	newTransition.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMove);
	newTransition.name = "level_temp";
	lvl_mc.addChild(newTransition);
}