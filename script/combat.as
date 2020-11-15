//Combat Module, Codename: Firestorm

//This .as file controls all of the combat related code.

//calculate final damage
function calculateFinalDamage(spellID):Number{
	var minDamage = spellTable[spellID][5];
	var maxDamage = spellTable[spellID][6];
	var finalDamage:Number;
	var damageType = spellTable[spellID][12];
	if(damageType == "Ranged"){
		finalDamage = Q_irand(minDamage, maxDamage);
		return finalDamage;
	} else if(damageType == "Melee"){
		finalDamage = Q_irand(minDamage, maxDamage);
		return finalDamage;
	} else{
		finalDamage = Q_irand(minDamage, maxDamage);
		return finalDamage;
	}
}

function dealDamage(victim:Object, attacker:Object, damageType:String, damage:Number){
	
	var finalDamage; //this is what we return
	//Don't use pointers here for damage! -rww
	//var defense = victim.stats.defense; //Defense reduces our damage
	var damageRnd; // = (damage + attacker.attackPower - defense);
	
			//Our resistances are factored in here
	var holyResistance:Number = victim.stats.resistances.holy;
	var fireResistance:Number = victim.stats.resistances.fire;
	var frostResistance:Number = victim.stats.resistances.frost;
	var natureResistance:Number = victim.stats.resistances.nature;
	var shadowResistance:Number = victim.stats.resistances.shadow;
	
	//Defense calcs
	var dodgeChance = victim.stats.dodge;
	
	if(damageType == "Melee" || damageType == "Ranged"){
		if(damageType == "Ranged"){
			damageRnd = (damage + attacker.stats.rangedPower/* - defense*/);
			dodgeChance *= 2; //Dodge is always doubled for ranged weapons.
			//To this end, Dodge is capped at 48%, or else YOUR GAME WILL CRASH!
		} else{
			damageRnd = (damage + attacker.stats.attPower/* - defense*/);
		}
		if(Q_irand(dodgeChance, 100) <= dodgeChance){ //hacky method of checking for dodge, but it works
			return 0; //No damage for you!
		}
	} else{
		damageRnd = (damage + attacker.stats.spellPower); //Defense doesn't factor in.
		//Neither does dodge.
		if(damageType == "Holy"){
			damageRnd *= (100/(holyResistance+1));
		} else if(damageType == "Fire"){
			damageRnd *= (100/(fireResistance+1));
		} else if(damageType == "Frost"){
			damageRnd *= (100/(frostResistance+1));
		} else if(damageType == "Nature"){
			damageRnd *= (100/(natureResistance+1));
		} else if(damageType == "Shadow"){
			damageRnd *= (100/(shadowResistance+1));
		}
	}
	return damageRnd;
}