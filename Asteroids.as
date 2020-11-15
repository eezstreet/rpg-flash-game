package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	import flash.geom.Point;
	
	public class Asteroids extends MovieClip {
		
		const topEdge:int = 0;
		const leftEdge:int = 0;
		const rightEdge:int = 800;
		const bottomEdge:int = 556;
		
		private var spaceship:SpaceShip;
		private var asteroids:Array;
		private var bullets:Array;
		private var gameField:MovieClip;
		private var score:int;
		private var lives:int;
		private var level:int;
		
		private var oldTime:int = 0;
		
		private var turnLeft:Boolean;
		private var turnRight:Boolean;
		private var thrust:Boolean;
		
		private var rotateSpeed:Number = 0.2;
		private var thrustAmt:Number = 0.2;
		private var shipStartX:int = 400;
		private var shipStartY:int = 280;
		private var shipDX:Number;
		private var shipDY:Number;
		private var bulletSpeed:Number = 0.5;
		private var maxBullets:int = 3;
		
		private var colPoint1:Point = new Point(-7,-19);
		private var colPoint2:Point = new Point(7,-19);
		private var colPoint3:Point = new Point(-22,14);
		private var colPoint4:Point = new Point(22,14);
		
		private var inGame:Boolean;
		
		public function startGame() {
			score = 0;
			level = 0;
			lives = 3;
			controlPanel.livesText.text = String(lives);
			asteroids = new Array();
			gameField = new MovieClip();
			addChild(gameField);
			this.setChildIndex(controlPanel,this.numChildren-1);
			bullets = new Array();
			// Add listeners
			stage.addEventListener(Event.ENTER_FRAME, gameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyIsUp);
			// Start the game
			addShip();			
			messages.gotoAndPlay("getready");
			messages.addEventListener(Event.ENTER_FRAME, messageHandler);
		}
		
		public function gameLoop(evt:Event) {
			var timeFrame:int = getTimer() - oldTime;
			oldTime+=timeFrame;
			moveSpaceship(timeFrame);
			moveBullets(timeFrame);
			if(asteroids.length>0) {				
				moveAsteroids(timeFrame);	
				checkCollisions();
				showScores();
			}
		}
		
		public function nextLevel() {
			level++;
			controlPanel.levelText.text = String(level);
			for(var i:int = level+1;i>0;i--) {
				var quadrant:int = Math.round(Math.random() * (4 - 1)) + 1;
				if(quadrant==1) {
					var thisX:int = Math.round(Math.random() * (250 - 100)) + 100;
					var thisY:int = Math.round(Math.random() * (200 - 100)) + 100;
					addAsteroid("big", thisX, thisY);
				} else if(quadrant==2) {
					thisX = Math.round(Math.random() * (700 - 550)) + 550;
					thisY = Math.round(Math.random() * (200 - 100)) + 100;
					addAsteroid("big", thisX, thisY);
				} else if(quadrant==3) {
					thisX = Math.round(Math.random() * (250 - 100)) + 100;
					thisY = Math.round(Math.random() * (500 - 400)) + 400;
					addAsteroid("big", thisX, thisY);
				} else if(quadrant==4) {
					thisX = Math.round(Math.random() * (700 - 550)) + 550;
					thisY = Math.round(Math.random() * (500 - 400)) + 400;
					addAsteroid("big", thisX, thisY);
				}
			}
		}
		
		public function addShip() {
			spaceship = new SpaceShip();
			spaceship.x = shipStartX;
			spaceship.y = shipStartY;
			shipDX = 0;
			shipDY = 0;			
			spaceship.gotoAndStop(1);
			gameField.addChild(spaceship);
			inGame = true;
		}
		
		public function fireBullet() {
			if(bullets.length<maxBullets) {
				// Create and position a new bullet
				var newBullet:Bullet = new Bullet();
				newBullet.dx = Math.sin(Math.PI*spaceship.rotation/180);
				newBullet.dy = -Math.cos(Math.PI*spaceship.rotation/180);
				newBullet.x = spaceship.x + newBullet.dx*5;
				newBullet.y = spaceship.y + newBullet.dy*5;
				gameField.addChild(newBullet);
				bullets.push(newBullet);
			}
		}
		
		public function addAsteroid(asteroidType:String, thisX:int, thisY:int) {
			var newAsteroid:MovieClip;
			if(asteroidType=="big") {
				newAsteroid = new BigRock();
				newAsteroid.dx = Math.random()*2.5-1.0;
				newAsteroid.dy = Math.random()*2.5-1.0;
			} else if(asteroidType=="medium") {
				newAsteroid = new MediumRock();
				newAsteroid.dx = Math.random()*4.0-1.0;
				newAsteroid.dy = Math.random()*4.0-1.0;
			} else if(asteroidType=="small") {
				newAsteroid = new SmallRock();
				newAsteroid.dx = Math.random()*6.0-1.0;
				newAsteroid.dy = Math.random()*6.0-1.0;
			}
			newAsteroid.asteroidType = asteroidType;
			newAsteroid.x = thisX;
			newAsteroid.y = thisY;
			newAsteroid.rotation =  Math.random();
			asteroids.push(newAsteroid);
			gameField.addChild(newAsteroid);
		}
		
		public function moveSpaceship(timeFrame:int) {
			if(inGame) {
				// Move spaceship
				if(turnLeft) {
					spaceship.rotation-=rotateSpeed*timeFrame;
				} else if(turnRight) {
					spaceship.rotation+=rotateSpeed*timeFrame;
				}
				if(thrust) {
					shipDX += Math.sin(Math.PI*spaceship.rotation/180)*thrustAmt;
					shipDY -= Math.cos(Math.PI*spaceship.rotation/180)*thrustAmt;
					spaceship.gotoAndStop("thrust");
				} else {
					spaceship.gotoAndStop(1);
				}
				spaceship.x += shipDX;
				spaceship.y += shipDY;
				// Wrap spaceship
				if(spaceship.x>rightEdge+20) {
					spaceship.x=leftEdge-20;
				} else if(spaceship.x<leftEdge-20) {
					spaceship.x=rightEdge+20;
				} else if(spaceship.y>bottomEdge+20) {
					spaceship.y=topEdge-20;
				} else if(spaceship.y<topEdge-20) {
					spaceship.y=bottomEdge+20;
				}
			}
		}
		
		public function moveBullets(timeFrame:int) {
			// Move bullets...			
			for(var i:int=bullets.length-1;i>=0;i--) {
				bullets[i].x += bullets[i].dx*bulletSpeed*timeFrame;
				bullets[i].y += bullets[i].dy*bulletSpeed*timeFrame;
				if(bullets[i].x<leftEdge || bullets[i].x>rightEdge || bullets[i].y<topEdge || bullets[i].y>bottomEdge) {
					removeBullet(i);
				}
			}
		}
		
		public function moveAsteroids(timeFrame:int) {
			// Move Asteroids
			for each(var asteroid:MovieClip  in asteroids) {
				asteroid.x += asteroid.dx;
				asteroid.y += asteroid.dy;
				asteroid.rotation += asteroid.dx - asteroid.dy; // Saves having to use another variable!
				// Wrap asteroid
				if(asteroid.x>rightEdge+20) {
					asteroid.x=leftEdge-20;
				} else if(asteroid.x<leftEdge-20) {
					asteroid.x=rightEdge+20;
				} else if(asteroid.y>bottomEdge+20) {
					asteroid.y=topEdge-20;
				} else if(asteroid.y<topEdge-20) {
					asteroid.y=bottomEdge+20;
				}
			}
		}
		
		public function checkCollisions() {
			//Check ship colision
			if(inGame) { 
				for(var i:int=asteroids.length-1;i>=0;i--) {
					if(asteroids[i].hit.hitTestPoint(spaceship.localToGlobal(colPoint1).x, spaceship.localToGlobal(colPoint1).y, true) || asteroids[i].hit.hitTestPoint(spaceship.localToGlobal(colPoint2).x, spaceship.localToGlobal(colPoint2).y, true) || asteroids[i].hit.hitTestPoint(spaceship.localToGlobal(colPoint3).x, spaceship.localToGlobal(colPoint3).y, true) || asteroids[i].hit.hitTestPoint(spaceship.localToGlobal(colPoint4).x, spaceship.localToGlobal(colPoint4).y, true)) {
						explodeSpaceship();
					}  
				}
			}
			// Check bullet colisions
			if(bullets.length>0 && asteroids.length>0) {
				loopAsteroids: for(i=asteroids.length-1;i>=0;i--) {
					loopBullets: for(var j:int=bullets.length-1;j>=0;j--) {
						if(asteroids[i].hit.hitTestPoint(bullets[j].x, bullets[j].y, true)) {
							removeAsteroid(i);
							removeBullet(j);
							// Break loop and check next asteroid...
							continue loopAsteroids;
						} 
					} 
				}
			}
		}
		
		public function removeAsteroid(asteroid:int) {
			// Add score, and create smaller asteroids if necessary...
			if(asteroids[asteroid].asteroidType=="big") {
				addAsteroid("medium", asteroids[asteroid].x,  asteroids[asteroid].y);
				addAsteroid("medium", asteroids[asteroid].x,  asteroids[asteroid].y);
				score+=50;
			} else if(asteroids[asteroid].asteroidType=="medium") {
				addAsteroid("small", asteroids[asteroid].x,  asteroids[asteroid].y);
				addAsteroid("small", asteroids[asteroid].x,  asteroids[asteroid].y);
				score+=30;
			} else {
				score+=15;
			}
			// Remove asteroid and end level if last one...
			gameField.removeChild(asteroids[asteroid]);
			asteroids.splice(asteroid,1);
			if(asteroids.length==0) {
				messages.gotoAndPlay("nextlevel");
				messages.addEventListener(Event.ENTER_FRAME, messageHandler);
			}
		}
		
		public function removeBullet(bullet:int) {
			gameField.removeChild(bullets[bullet]);
			bullets.splice(bullet,1);
		}
		
		public function explodeSpaceship() {
			inGame = false;
			gameField.setChildIndex(spaceship,gameField.numChildren-1);
			spaceship.gotoAndPlay("explode");
			spaceship.addEventListener(Event.ENTER_FRAME, removeSpaceship);
			lives--;
			controlPanel.livesText.text = String(lives);
		}
		
		public function removeSpaceship(evt:Event) {
			if(spaceship.currentLabel=="explodeEnd") {
				gameField.removeChild(spaceship);
				spaceship.removeEventListener(Event.ENTER_FRAME, removeSpaceship);
				if(lives>0) {
					addShip();
				} else {
					messages.addEventListener(Event.ENTER_FRAME, messageHandler);
					this.setChildIndex(messages,this.numChildren-1);
					messages.gotoAndPlay("gameover");
				}
			}
		}
		
		public function messageHandler(evt:Event) {
			if(messages.currentLabel=="endlevel") {
				messages.removeEventListener(Event.ENTER_FRAME, messageHandler);
				nextLevel();
			} else if(messages.currentLabel=="end") {
				messages.removeEventListener(Event.ENTER_FRAME, messageHandler);
				gotoAndStop("gameover");
			}
		}
		
		public function showScores() {
			controlPanel.scoreText.text = String(score);
		}
		
		public function restartGame() {
			for(var i:int=asteroids.length-1;i>=0;i--) {
				gameField.removeChild(asteroids[i]);
				asteroids.splice(i,1);
			}
			gotoAndStop(1);
		}
		
		public function keyIsDown(evt:KeyboardEvent) {
			if(evt.keyCode==37) {
				turnLeft = true;
			} else if(evt.keyCode==39) {
				turnRight = true;
			} else if(evt.keyCode==38) {
				thrust = true;
			} else if(evt.keyCode==88) {
				fireBullet();
			}
		}
		
		public function keyIsUp(evt:KeyboardEvent) {
			if(evt.keyCode==37) {
				turnLeft = false;
			} else if(evt.keyCode==39) {
				turnRight = false;
			} else if(evt.keyCode==38) {
				thrust = false;
			}
		}
		
	}
}