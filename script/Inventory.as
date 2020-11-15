//inventory action
function inventory_action(action:String, item:Array, count:int = 1):void {
	
	var i:int;
	
	// if we are using the item
	if(action == "use") {
		
		// loop through inventory
		for(i = 0; i < 20; i++) {
			if(hero.inventory[i]) {
				if(hero.inventory[i][0] == item[0]) {
					if(hero.inventory[i][3] == 1){
						Readmenu_open("newspaper");
					}
					else{
						hero.inventory[i][4] -= count;
						if(hero.inventory[i][4] <= 0) {
							inventory_action("drop", item);
						}
						break;
					}
				}
			}
		}
	
	// if we are ridding of the item
	} else if(action == "drop") {
		
		// again, lets loop
		for(i = 0; i < 20; i++) {
			if(hero.inventory[i]) {
				if(hero.inventory[i][1] == item[1]) {
					hero.inventory.splice(i,1);
				}
			}
		}
	
	// if we are going to add an item
	} else if(action == "add") {
		
		// checks if we found the item or not when looping
		var found:Boolean = false;
		
		// loop to check if we have the item, if we have the item to already increment the count
		for(i = 0; i < 20; i++) {
			if(hero.inventory[i]) {
				if(hero.inventory[i][1] == item[1]) {
					hero.inventory[i][4] += count;
					found = true;
					break;
				}
			}
		}

		// if found is still false, we add it, IF hero.inventory.length is less than 20
		if(hero.inventory.length < 20) {
			if(!found) {
				hero.inventory.push(item);
			}
		}
		
	} else if(action == "deposit"){
		hero.totalHex += count;
	}
	
}

// add an item to our backpack -- used for dialogue, selling, etc.
function addItemToBackpack(id:int, count:int){
	var values:Array = new Array();
	values[0] = itemTable[0][id];
	values[1] = itemTable[1][id];
	values[2] = itemTable[2][id];
	values[3] = itemTable[3][id];
	values[4] = count;
	values[5] = itemTable[4][id];
	values[6] = itemTable[5][id];
	
	inventory_action("add", values, int(values[4]));
	if(game.mc.getChildByName("ingamemenu").currentLabel == "inventory") {
					game.mc.getChildByName("ingamemenu").nextFrame();
	}
}