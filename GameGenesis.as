package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.ui.Keyboard;
	//import flash.
	
	public class GameGenesis extends MovieClip
	{
		public function Game_Begin(){
			game.mc.centeredX = 0;
			game.mc.centeredY = 0;
	
			// add game mc to stage
			addChild(game.mc);
	
			// add hero to game.mc, place in center of game screen
			game.mc.addChild(hero.mc);
			hero.mc.x = game.sw / 2;
			hero.mc.y = game.sh / 2;
	
			// add level to game.mc
			var lvl:Level = new Level();
			lvl.name = "gamelevel";
			lvl.width *= 2;
			lvl.height *= 2;
			game.mc.addChild(lvl);
	
			// set the items in the stage
			set_level_items(lvl);
	 
	
			//BugFix: Hex is not undefined at start of game.
			hero.totalHex = 0;
	
			var igm:InGameMenu = new InGameMenu();
			igm.name = "ingamemenu";
			game.mc.addChild(igm);
		
			//add cursor
			//game.mc.addChild(cursor.mc);
			//cursor.mc.x = mouseX;
			//cursor.mc.y = mouseY;
			//Mouse.hide();
	
			// add event listeners
			stage.addEventListener(Event.ENTER_FRAME, game_loop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keys_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, keys_up);
	
			initQuestData();
			initSpells();
			initExperience();
		}
	}
}