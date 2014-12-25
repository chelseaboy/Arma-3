private["_unit","_rand","_damage", "_fatigue"];

_unit = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;

if(isNull _unit) exitWith {};
if(playerSide == west) exitWith {};
if(life_action_inUse) exitWith {};
if(player distance _unit > 5 || !alive player || !alive _unit) exitWith 
{
	hint "Vous ne pouvez pas torturer la personne."
};

life_action_inUse = true;

_rand = [0,4] call life_fnc_randomRound;

switch(_rand) do 
{
	case 0:
	{
		hintSilent "Vous l'avez frappé dans l'estomac.";
		_damage = damage _unit;
		_damage = _damage + 0.07;
		if(_damage >= 1) then 
		{
			_damage = 0.95;
		};
		_unit setDamage _damage;
		_fatigue = getFatigue _unit;
		_fatigue = _fatigue + 0.2;
		if(_fatigue >= 1) then 
		{ 
			_fatigue = 1;
		};
		_unit setFatigue _fatigue;
		_unit say3D "punch";
	};

	case 1:
	{
		hintSilent "Vous l'avez frappé au visage.";
		_damage = damage _unit;
		_damage = _damage + 0.1;
		if(_damage >= 1) then 
		{ 
			_damage = 0.98; 
		};
		_unit setDamage _damage;
		_fatigue = getFatigue _unit;
		_fatigue = _fatigue + 0.25;
		if(_fatigue >= 1) then 
		{ 
			_fatigue = 1; 
		};
		_unit say3D "punch";
	};

	case 2:
	{
		hintSilent "Tu l'as frappé";
		_damage = damage _unit;
		_damage = _damage + 0.11;
		if(_damage >= 1) then 
		{ 
			_damage = 0.98; 
		};
		_unit setDamage _damage;
		_fatigue = getFatigue _unit;
		_fatigue = _fatigue + 0.1;
		if(_fatigue >= 1) then 
		{ 
			_fatigue = 1; 
		};
		_unit say3D "punch_break";
	};

	case 3:
	{
		hintSilent "Vous avez mis des coups de pieds dans ses couilles.";
		_damage = damage _unit;
		_damage = _damage + 0.5;
		if(_damage >= 1) then 
		{ 
			_damage = 0.99; 
		};
		_unit setDamage _damage;
		_unit setFatigue 1;
		_unit say3D "punch_balls";
	};
	default
	{
		hintSilent "Vous lui avez brisé les dents.";
		_damage = damage _unit;
		_damage = _damage + 0.1;
		if(_damage >= 1) then { _damage = 0.98; };
		_unit setDamage _damage;
		_fatigue = getFatigue _unit;
		_fatigue = _fatigue + 0.1;
		if(_fatigue >= 1) then 
		{ 
			_fatigue = 1; 
		};
		_unit say3D "punch";
	};
};

life_action_inUse = false;

[[getPlayerUID player,name player,"",["Folter",800]],"life_fnc_wantedAdd",false,false] spawn life_fnc_MP;