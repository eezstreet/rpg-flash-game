//import AI_MODE;
function doWarriorAI(monster:MovieClip):void{
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	var num_children:int = lvl_mc.numChildren;
	for(var j:int = 0; j < num_children; j++) {
		if(!num_children){
				break;
			}
			var mc = lvl_mc.getChildAt(j);
		
			if(mc.name.indexOf("collideBox") != -1) {
				hit_test(monster, mc, false);
			}
	}
	//todo: make the AI
	if(monster.aiMode == undefined){
		monster.aiMode = MODE_SCAN;
	}
	switch(monster.aiMode){ //We do certain things based on our AI
		case MODE_SCAN:
			//The monster will continuously scan
			if(monster.rotation < Q_irand(60,140)){
				monster.rotation++;
				//monster.rotationOffset++;
			}
			else if(monster.rotation > Q_irand(60,140)){
				//monster.aiMode = Q_irand(MODE_SCAN_BACK, MODE_SCAN_BACK); //wtf?
				monster.aiMode = MODE_SCAN_BACK;
			}
			else{
				monster.rotation++;
			}
			if(monster.inPain){
				monster.aiMode = MODE_CHASE;
			}
			break;
		case MODE_SCAN_BACK:
			if(monster.rotation > 0){
				monster.rotation--;
				//monster.rotationOffset--;
			} else{
				monster.aiMode = MODE_SCAN;
				//monster.aiMode = Q_irand(MODE_SCAN, MODE_THINK);
			}
			if(monster.inPain){
				monster.aiMode = MODE_CHASE;
			}
			break;
		case MODE_THINK:
			monster.thinkTime++;
			if(monster.thinkTime >= 400){
				monster.aiMode = MODE_SCAN_BACK; //The AI hangs when we use MODE_SCAN
			}
			if(monster.inPain){
				monster.aiMode = MODE_CHASE;
			}
			break;
		case MODE_CHASE:
			var a = hero.mc.y - monster.y;
			var b = hero.mc.x - monster.x;
			var radians = Math.atan2(a,b);
			var degrees = radians / (Math.PI / 180);
			monster.rotation = degrees;
			monster.rotation += monster.rotationOffset;
			if(monster.x <= hero.mc.x){
				monster..x++;
			} else if(monster.x >= hero.mc.x){
				monster.x--;
			} if(monster.y <= hero.mc.y){
				monster.y++;
			} else if(monster.y >= hero.mc.y){
				monster.y--;
			} if(!inRadiusOf(hero.mc, monster, 350)){
				//We're outside the radius.
				monster.aiMode = MODE_THINK;
			} else if(inRadiusOf(hero.mc, monster, monsterTable[monster.pointer][13])){
				//We're in attack range. Start attacking.
				monster.aiMode = MODE_ATTACK;
			}
			break;
		case MODE_ATTACK:
			if(!inRadiusOf(hero.mc, monster, 40)){
				//We're now outside of attack range. Chase 'dem!
				monster.aiMode = MODE_CHASE;
			} else{
				if(monster.health <= 0){
					return; //We are in the middle of an AI cycle when we died, so return immediately.
				//This will override any AI params!
				}
				//Attack.
				monster.attackDelay++;
				if(monster.attackDelay >= 100){
					monsterAttack(monster, hero);
					monster.attackDelay = 0;
				}
			}
			break;
		case MODE_PATROL:
			patrolArea(monster);
			break;
			
	}
	//In the game, if we're still in pain, we'll chase a target regardless of range.
	if(monster.inPain){
		monster.painTime--;
		if(monster.painTime >= 0){
			monster.inPain = false;
		}
	}
}
