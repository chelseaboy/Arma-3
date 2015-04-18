private "_container";
_container = [_this,1,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull _container) exitWith {};

if((typeOf _container) in ["Box_IND_Grenades_F","B_supplyCrate_F"]) exitWith 
{
	_house = lineIntersectsWith [getPosASL player, ATLtoASL screenToWorld[0.5,0.5]];
	switch(true) do 
	{
		case (count _house == 0): {_exit = true;};
		case (count _house == 1): {_house = _house select 0;};
		default 
		{
			{
				if(_x isKindOf "House_F") exitWith {_house = _x;};
			} foreach _house;
		};
	};
	if(!isNil "_exit" OR !(_house isKindOf "House_F")) exitWith {systemChat "Error saving container, couldn't locate house?"};
	[[_house],"TON_fnc_updateHouseContainers",false,false] call life_fnc_MP;
};