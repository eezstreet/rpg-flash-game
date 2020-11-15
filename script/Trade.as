// TRADE FUNCTIONS
//buy item
function buyItem(itemID:int, stack:int){
	var values:Array = new Array();
	values[0] = itemTable[0][itemID];
	values[1] = itemTable[1][itemID];
	values[2] = itemTable[2][itemID];
	values[3] = itemTable[3][itemID];
	values[4] = stack; //stack determines how many we buy at once
	values[5] = itemTable[4][itemID];
	
	inventory_action("add", values, stack);
	if(game.mc.getChildByName("ingamemenu").currentLabel == "inventory") {
		game.mc.getChildByName("ingamemenu").nextFrame();
	}
	hero.totalHex -= itemTable[4][itemID] * stack;
			
}
function sellItem(itemID:int, stack:int, vendorID:int){
	var weBroke:Boolean = false;
	for( var i:int = 0; i < vendorTable[vendorID].length-1 + 1; i++){
		if(itemID == vendorTable[vendorID][i]){
			weBroke = true;
			break;
		}
		else{
			continue;
		}
	}
	if(!weBroke){
		trace("The vendor doesn't want this item.");
		return;
	}
	hero.totalHex += itemTable[4][itemID] * stack;
	
}