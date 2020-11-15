// key detection
var keys:Object = new Object();
keys[65] = keys[Keyboard.LEFT] = false;
keys[68] = keys[Keyboard.RIGHT] = false;
keys[87] = keys[Keyboard.UP] = false;
keys[83] = keys[Keyboard.DOWN] = false;
keys[32] = keys[Keyboard.SPACE] = false;
keys[88] = false; //x
keys[90] = false; //z
keys[30] = false; //space bar

// key events -- not used
function keyEvent(e:KeyboardEvent):void{
	var zKey:Boolean = keys[90];
	var xKey:Boolean = keys[88];
	var keyASCII = e.keyCode;
	
	switch(keyASCII){
		case 88:
			xKey = true;
			break;
		case 90:
			zKey = true;
			break;
	}
	
	if(zKey){
		prevSpell();
	}
	else if(xKey){
		nextSpell();
	}
}

// key down and up functions
function keys_down(e:KeyboardEvent):void {
	if(keys[e.keyCode] !== undefined) {
		keys[e.keyCode] = true;
	}
	keyEvent(e);
}
function keys_up(e:KeyboardEvent):void {
	if(keys[e.keyCode] !== undefined) {
		keys[e.keyCode] = false;
	}
}