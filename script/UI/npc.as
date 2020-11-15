var inNPCMenu:Boolean = false;

var maxNPCDistance:int = 40;

var savedHeroX:int;
var savedHeroY:int;

var savedRootX:int;
var savedRootY:int;

function NPCmenu_open(menuID:String){
	var root_mc:MovieClip = MovieClip(root);
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	
	savedHeroX = hero.mc.x;
	savedHeroY = hero.mc.y;
	
	/*root_mc.x += 10000000;
	root_mc.y += 10000000;
	
	lvl_mc.x += 1000000;
	lvl_mc.y += 1000000;
	
	hero.mc.x += 1000000;
	hero.mc.y += 1000000;*/
	
	var npc:npcMenu = new npcMenu();
	npc.name = "npcmenu";
	game.mc.addChildAt(npc,1);
	game.mc.getChildByName("npcmenu").gotoAndStop(menuID);
	//game.mc.getChildByName("npcmenu").x = (game.mc.getChildByName("npcmenu").width / 2) + 20;
	//game.mc.getChildByName("npcmenu").y = (game.mc.getChildByName("npcmenu").height / 2) + 80;
	game.mc.getChildByName("npcmenu").x = root_mc.x + (npc.width / 2) + 20;
	game.mc.getChildByName("npcmenu").y = root_mc.y + (npc.height / 2) + 80;
	
	inNPCMenu = true;
}
function NPCmenu_close(){
	var root_mc:MovieClip = MovieClip(root);
	var lvl_mc:MovieClip = game.mc.getChildByName("gamelevel");
	game.mc.removeChild(game.mc.getChildByName("npcmenu"));
	
	lvl_mc.x -= 1000000;
	lvl_mc.y -= 1000000;
	
	hero.mc.x = (savedHeroX+10);
	hero.mc.y = (savedHeroY+10);
	
	inNPCMenu = false;
	game.mc.getChildByName("ingamemenu").nextFrame();
}