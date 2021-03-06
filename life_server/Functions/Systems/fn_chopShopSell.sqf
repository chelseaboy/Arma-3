private["_unit","_vehicle","_price","_money","_vInfo"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_vehicle = [_this,1,objNull,[objNull]] call BIS_fnc_param;
_price = [_this,2,500,[0]] call BIS_fnc_param;
_money = [_this,3,0,[0]] call BIS_fnc_param;

if(isNull _vehicle OR isNull _unit) exitWith 
{
	[["life_action_inUse",false],"life_fnc_netSetVar",nil,false] spawn life_fnc_MP;
};

_vInfo = _vehicle getVariable["dbInfo",[]];
if(count _vInfo == 0) exitWith
{
	diag_log format["%1 a essayé de vendre un véhicule non persistant au receleur.", name _unit];
	[[1,"Je ne veux pas acheter des voitures de location."],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;
	[["life_action_inUse",false],"life_fnc_netSetVar",_unit,false] spawn life_fnc_MP;
};

_displayName = getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
_unit = owner _unit;

_dbInfo = _vehicle getVariable["dbInfo",[]];
if(count _dbInfo > 0) then 
{
	_uid = _dbInfo select 0;
	_plate = _dbInfo select 1;
	_query = format["UPDATE vehicles SET alive='0' WHERE pid='%1' AND plate='%2'",_uid,_plate];
	waitUntil {!DB_Async_Active};
	_sql = [_query,1] call DB_fnc_asyncCall;
};

deleteVehicle _vehicle;
[["life_action_inUse",false],"life_fnc_netSetVar",_unit,false] spawn life_fnc_MP;
[["life_money",_money],"life_fnc_netSetVar",_unit,false] spawn life_fnc_MP;
[[2,format["Vous avez vendu un %1 pour %2 €",_displayName,[_price] call life_fnc_numberText]],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;