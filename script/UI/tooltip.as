function ltoolTip(e:MouseEvent){
	var mouseOverBox:PopupBox = new PopupBox();
	mouseOverBox.x = mouseX;
	mouseOverBox.y = mouseY;
	mouseOverBox.textFieldZ.text = e.currentTarget.levelName;
	mouseOverBox.name = "tooltip";
	addChild(mouseOverBox);
}
function toolTipRemove(e:MouseEvent){
	removeChild(getChildByName("tooltip"));
}
function toolTipMove(e:MouseEvent){
}

function toolTip(e:MouseEvent){
	var mouseOverBox:PopupBox = new PopupBox();
	mouseOverBox.x = mouseX;
	mouseOverBox.y = mouseY;
	mouseOverBox.textFieldZ.text = e.currentTarget.toolTipText;
	mouseOverBox.name = "tooltip";
	addChild(mouseOverBox);
}

function mToolTip(e:MouseEvent){
	var mouseOverBox:mPopUpBox = new mPopUpBox();
	mouseOverBox.x = mouseX;
	mouseOverBox.y = mouseY;
	mouseOverBox.textFieldZ.text = e.currentTarget.mToolTipText;
	mouseOverBox.name = "tooltip";
	addChild(mouseOverBox);
}

function rmToolTip(e:MouseEvent){
	removeChild(getChildByName("tooltip"));
}
/*function addToolTipToObject(object:DisplayObject, transition:Boolean){
	if(transition){
		object.addEventListener(MouseEvent.MOUSE_OVER, ltoolTip);
	}
	else{
		object.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
	}
	object.addEventListener(MouseEvent.MOUSE_OUT, toolTipRemove);
	object.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMove);
}*/