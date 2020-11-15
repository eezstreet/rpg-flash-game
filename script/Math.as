//Math module
//Has basic math functions, simplified.

//Q_irand: returns a random number within the range
//Oh look! A function that I took the name from Quake III ^.^
function Q_irand(min:Number, max:Number):Number{
	return Math.floor(Math.random() * (1+max-min)) + min;
	//Unfortunately for us, Flash doesn't have a simplified random function.
	//Sure, there's Math.random(), but it doesn't do ranges.
}

// Square a number
function Q_isqr(a:Number):Number{
	return (a*a);
}

// Return the percent of A in B
function Q_ipct(a:Number, b:Number):Number{
	return (a/b)*100;
}

// Applies a percent to a float/int/Number
function Q_iappct(percent:Number, integer:Number){
	return integer*(percent/100);
}

// Check to see if two objects are within a certain radius of each other in virtual space
function inRadiusOf(object1:Object, object2:Object, radius:int):Boolean{
	//our new InRadiusOf function
	//Another Math. function provided by eezMath inc (tm)
	var xdist = Math.round(object1.x - object2.x);
	var ydist = Math.round(object1.y - object2.y);
	var distanceFromThis = Math.round(Math.sqrt((Q_isqr(xdist) + Q_isqr(ydist))));
	if(distanceFromThis <= radius){
		return true;
	} return false;
}