// hit test between two movie clips. if flag is true, return true or false if we hit the movie clip. if flag is false, just move mc1 out of mc2's way
function hit_test(mc1:MovieClip, mc2:MovieClip, flag:Boolean = true) {
	
	if(!mc1){
		return true;
	}
	if(!mc2){
		return true;
	}
	// make a new point
	mc1.point = new Point(mc1.x, mc1.y);
	
	// left 
	while(mc2.hitTestPoint((mc1.point.x + (mc1.width / 2)), mc1.point.y, true)) {
		if(flag) {
			return true;
		} else { 
			mc1.x--;
			mc1.point.x--;
		}
	}
	// right
	while(mc2.hitTestPoint((mc1.point.x - (mc1.width / 2)), mc1.point.y, true)) {
		if(flag) {
			return true;
		} else {
			mc1.x++;
			mc1.point.x++;
		}
	}
	// top
	while(mc2.hitTestPoint(mc1.point.x, (mc1.point.y + (mc1.height / 2)), true)) {
		if(flag) {
			return true;
		} else {
			mc1.y--;
			mc1.point.y--;
		}
	}
	// bottom
	while(mc2.hitTestPoint(mc1.point.x, (mc1.point.y - (mc1.height / 2)), true)) {
		if(flag) {
			return true;
		} else {
			mc1.y++;
			mc1.point.y++;
		}
	}
	
	// if we made it down here, then its false
	if(flag) {
		return false;
	}
	
}
// center in middle of screen
function center(mc:MovieClip):void {
	
	if(inNPCMenu || inReadMenu){
		//You don't call, ya?
		return;
	}
	var centeredXAxis;
	var centeredYAxis;
	// movie clip we want to move, the root
	var root_mc:MovieClip = MovieClip(root);
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	
	// fix for x
	if(mc.x > (game.sw / 2)) {
		if(mc.x < (9000 - (game.sw / 2))){
			//centeredXAxis = Q_ipct(root_mc.x, levelWidth);
			//root_mc.x = Q_iappct(centeredXAxis, levelWidth);
			root_mc.x = (game.sw / 2) - mc.x;
		} else {
			//centeredXAxis = Q_ipct(root_mc.x, levelWidth);
			//root_mc.x = -(Q_iappct(centeredXAxis, levelWidth));
			root_mc.x = -(9000 - game.sw);
		}
	} else {
		root_mc.x = 0;
	}
	
	
	// fix for y
	if(mc.y > (game.sh / 2)) {
		if(mc.y < (9000 - (game.sh / 2))) {
			//centeredYAxis = Q_ipct(levelHeight, root_mc.y);
			//root_mc.y = Q_iappct(centeredYAxis, levelHeight);
			root_mc.y = (game.sh / 2) - mc.y;
		} else {
			//centeredYAxis = Q_ipct(levelHeight, root_mc.y);
			//root_mc.y = -(Q_iappct(centeredYAxis, levelHeight));
			root_mc.y = -(9000 - game.sh);
		}
	} else {
		root_mc.y = 0;
	}
	
	// get the menu and set its coordinates
	var igm_mc:MovieClip = game.mc.getChildByName("ingamemenu");
	//From a methematical standpoint, this makes NO sense.
	//But AS seems to think otherwise...
	igm_mc.x = Math.abs(root_mc.x);
	igm_mc.y = Math.abs(root_mc.y);
}

// Change the hero's direction based on the mouse's position
function mouseFollow():void {

	var a = mouseY - hero.mc.y;
	var b = mouseX - hero.mc.x;
	var radians = Math.atan2(a,b);
	var degrees = radians / (Math.PI / 180);
	hero.mc.rotation = degrees;
	
	//Mouse.hide();
	//cursor.visible = true;
	/*cursor.x = mouseX;
	cursor.y = mouseY;*/
}

// main game loop
function game_loop(e:Event):void {
	
	if(!inNPCMenu){
		// hero movement
		hero_move();
	
		// center in middle of screen, passing the movie clip we want to center
		center(hero.mc);
	}
	/*cursor.mc.x = mouseX;
	cursor.mc.y = mouseY;*/
	mouseFollow();
	
	
	var timeFrame:int = getTimer() - oldTime;
	moveTempEnts(timeFrame);
	clearThisCache(timeFrame);
	oldTime+=timeFrame;
	for(var i:int = 0; i < MAX_SPELLS; i++){
		if(hero.coolDownTable[i] > 0){
			hero.coolDownTable[i] -= timeFrame;
		}
	}
	/*for(i = 0; i < monsterArray.length-1; i++){
		if(monsterArray[i].health <= 0){
			killMonster(monsterArray[i]);
		}
	}*/
	mToolTipReload();

}