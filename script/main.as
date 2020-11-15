var game:Object = new Object();
game.mc = new MovieClip();
game.sw = stage.stageWidth; // sw is short for stage/scene width
game.sh = stage.stageHeight;

var cursor:Object = new Object();

var hero:Object = new Object();
hero.mc = new Hero();
hero.speed = 2;
hero.inventory = new Array();

var oldTime:int = 0;