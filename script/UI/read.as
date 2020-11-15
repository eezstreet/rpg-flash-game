var inReadMenu:Boolean = false;

//readmenu
function Readmenu_open(menuID:String){
	var root_mc:MovieClip = MovieClip(root);
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	
	if(inReadMenu){
		return;
	}
	savedHeroX = hero.mc.x;
	savedHeroY = hero.mc.y;
	
	lvl_mc.x += 10000;
	lvl_mc.y += 10000;
	
	hero.mc.x += 10000;
	hero.mc.y += 10000;
	
	var read:readMenu = new readMenu();
	read.name = "readmenu";
	game.mc.addChildAt(read, 0);
	game.mc.getChildByName("readmenu").gotoAndStop(menuID);
	//game.mc.getChildByName("readmenu").x = Math.abs((game.mc.getChildByName("readmenu").width / 2) - 185);
	//game.mc.getChildByName("readmenu").y = (game.mc.getChildByName("readmenu").height / 2) - 185;
	
	//game.mc.getChildByName("readmenu").x = Math.abs(root_mc.x);
	//game.mc.getChildByName("readmenu").y = Math.abs(root_mc.y);
	game.mc.getChildByName("readmenu").x = (game.mc.getChildByName("readmenu").width / 2) + 20;
	game.mc.getChildByName("readmenu").y = (game.mc.getChildByName("readmenu").height / 2) + 80;
	
	inReadMenu = true;
}
function Readmenu_close(){
	var root_mc:MovieClip = MovieClip(root);
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	if(!inReadMenu){
		return;
	}
	game.mc.removeChild(game.mc.getChildByName("readmenu"));
	
	lvl_mc.x -= 10000;
	lvl_mc.y -= 10000;
	
	hero.mc.x = (savedHeroX+10);
	hero.mc.y = (savedHeroY+10);
	
	inReadMenu = false;
	game.mc.getChildByName("ingamemenu").nextFrame();
}