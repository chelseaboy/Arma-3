private["_cop","_drinky"];

_cop = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull _cop) exitWith {};
_drinky = life_drink;

if(_drinky > 0.07) then 
{
	[[1,format["Breathalyzing %1 \n\n BAC: %2 \n\n Au dessus de la limite l�gale! ",name player,[_drinky] call life_fnc_numberText]],"life_fnc_broadcast",_cop,false] spawn life_fnc_MP;
} else {
	[[1,format["Breathalyzing %1 \n\n BAC: %2 \n\n En dessous de la limite l�gale! ",name player,[_drinky] call life_fnc_numberText]],"life_fnc_broadcast",_cop,false] spawn life_fnc_MP;
};