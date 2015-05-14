private["_dialog","_list","_plist","_sel","_vehicle","_owners","_index","_unit","_uid"];
disableSerialization;

_dialog = findDisplay 2700;
_list = _dialog displayCtrl 2701;
_plist = _dialog displayCtrl 2702;
_sel = lbCurSel _list;
_vehicle = _list lbData _sel;
_vehicle = life_vehicles select parseNumber(_vehicle);
_sel = lbCurSel _plist;
_unit = _plist lbData _sel;
_unit = call compile format["%1", _unit];
if(isNull _unit OR isNil "_unit") exitWith {}; 
_uid = getPlayerUID _unit;
_owners = _vehicle getVariable "vehicle_info_owners";
_index = [_uid,_owners] call fnc_index;

if(_index == -1) then 
{
	_owners pushBack [_uid,_unit getVariable["realname",name _unit]];
	_vehicle setVariable["vehicle_info_owners",_owners,true];
};

hint format["Vous avez donné d'une façon permanente les clés de %1 a votre gang.",typeOf _vehicle];
[[_vehicle, getPlayerUID player, 0],"TON_fnc_insertHouseGangKey",false,false] call life_fnc_MP;