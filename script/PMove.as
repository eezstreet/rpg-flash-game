function hero_move():void {
	if(inNPCMenu){
		return;
	}
	// get game level
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	
	var left:Boolean = keys[65] || keys[Keyboard.LEFT];
	var right:Boolean = keys[68] || keys[Keyboard.RIGHT];
	var up:Boolean = keys[87] || keys[Keyboard.UP];
	var down:Boolean = keys[83] || keys[Keyboard.DOWN];
	var cast:Boolean = keys[32] || keys[Keyboard.SPACE];
	
	var root_mc:MovieClip = MovieClip(root);
	
	// move the hero
	if(left) {
		if(hero.mc.x > 0) {
			hero.mc.x -= hero.speed;
		}
		//hero.mc.rotation = 180;
	} else if(right) {
		if(hero.mc.x < lvl_mc.width) {
			hero.mc.x += hero.speed;
		}
		//hero.mc.rotation = 0;
	} if(up) {
		if(hero.mc.y > 0) {
			hero.mc.y -= hero.speed;
		}
		//hero.mc.rotation = -90;
	} else if(down) {
		if(hero.mc.y < lvl_mc.height) {
			hero.mc.y += hero.speed;
		}
		//hero.mc.rotation = 90;
	} 
	if(cast){
		castSpell();
	}
	
	// get the number of children in the movie clip, and then loop through all movieclips in the level
	var num_children:int = lvl_mc.numChildren;
	for(var i:int = 0; i < num_children; i++) {
		
		// holder of mc
		var mc = lvl_mc.getChildAt(i);
		
		// used to determine if we are hitting the mc
		var hit_mc:Boolean;
		
		if(mc.name.indexOf("collideBox") != -1 || mc.name.indexOf("questTape") != -1) {
			hit_test(hero.mc, mc, false);
			
		} else if(mc.name.indexOf("item") != -1) {
			// will return either true or false depending if our hero hit the item
			hit_mc = hit_test(hero.mc, mc, true);
			
			// if true, lets remove the item and it to our inventory
			if(hit_mc) {
				
				var values:Array = new Array();
				
				values[0] = itemTable[0][mc.itemID];
				values[1] = itemTable[1][mc.itemID];
				values[2] = itemTable[2][mc.itemID];
				values[3] = itemTable[3][mc.itemID];
				values[4] = itemTable[4][mc.itemID];
				values[5] = itemTable[5][mc.itemID];
				// add to inventory
				inventory_action("add", values, 2);
				
				// refresh the inventory menu IF the inventory menu is open... this helps keep the inventory status up to date
				if(game.mc.getChildByName("ingamemenu").currentLabel == "inventory") {
					game.mc.getChildByName("ingamemenu").nextFrame();
				}
				
				// remove it
				lvl_mc.removeChild(mc);
				
				// break out of the for loop so we don't cause an error when looping through the children of the level movieclip
				break;
				
			} 
			
		} else if(mc.name.indexOf("hex") != -1){
			
				hit_mc = hit_test(hero.mc, mc, true);
				
				if(hit_mc){
					var values2:Array = mc.name.split("_");
					
					inventory_action("deposit", null, values2[1]);
					lvl_mc.removeChild(mc);
				game.mc.getChildByName("ingamemenu").nextFrame();
				break;
				}
			} else if(mc.name.indexOf("level") != -1){
				hit_mc = hit_test(hero.mc, mc, true);
				
				if(hit_mc){
					transitionBetweenLevels(mc);
				}
			} else if(mc.name.indexOf("npc") != -1){
				hit_mc = hit_test(hero.mc, mc, true);
				
				if(hit_mc){
					values2 = mc.name.split("_");
					if(values2[2] == "none"){
						return;
					}
					NPCmenu_open(values2[2]);
				}
			} else if(mc.name.indexOf("rpc") != -1){
				hit_test(hero.mc, mc, false);
			} else if(mc.name.indexOf("xpc") != -1){
				if(!inRadiusOf(hero.mc, mc, 1000)){
					mc.visible = false;
				} else if(inRadiusOf(hero.mc, mc, 1000)){
					mc.visible = true;
				}
				hit_test(hero.mc, mc, false);
			} else if(mc.name.indexOf("loadZone") != -1){
			} else if(mc.name.indexOf("ferry") != -1){
				hit_mc = hit_test(hero.mc, mc, true);
				values2 = mc.name.split("_");
				if(hit_mc){
					hero.x += values2[1];
					hero.x -= values2[2];
					hero.y += values2[3];
					hero.y -= values2[4];
				}
			} else if(mc.name.indexOf("ntrigger") != -1){
				hit_mc = hit_test(hero.mc, mc, true);
				if(hit_mc){
					absoluteLevelName = mc.levelName;
					game.mc.getChildByName("ingamemenu").nextFrame();
				} else{
					//Do nothing.
				}
			}
		
	} // end for i loop

}