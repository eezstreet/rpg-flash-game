//Helper functions
function createCustomButton(instance:String, words:String){
	var ourButton:customButton = new customButton();
	ourButton.name = "" + instance;
	game.mc.addChild(ourButton);
}

function addSimpleHoverOver(object:MovieClip, hoverOverObject:MovieClip, frameL:String){
	var defaultPhase = object.currentFrame; //Phase object
	hoverOverObject.alpha = 0;
	hoverOverObject.buttonMode = true;
	//Assert if we don't have a frame.
	if(!frameL){
		trace("addSimpleHoverOver: attempted to call without a frame label.");
		return;
	}
	else if(object == hoverOverObject){
		//We are our own hoverOverObject, essentially.
		hoverOverObject.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent){
			e.currentTarget.gotoAndStop(frameL);
																					  });
		hoverOverObject.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent){
			e.currentTarget.gotoAndStop(defaultPhase);
																					 });
		//Bug fixed: updates donh't glitch us
		hoverOverObject.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent){
			e.currentTarget.gotoAndStop(defaultPhase);
																					 });
	} else{
		hoverOverObject.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent){
			object.gotoAndStop(frameL);
																					  });
		hoverOverObject.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent){
			object.gotoAndStop(defaultPhase);
																					 });
	}
}