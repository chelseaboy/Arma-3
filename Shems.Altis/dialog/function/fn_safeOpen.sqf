if(dialog) exitWith {};
life_safeObj = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull life_safeObj) exitWith {};
if(playerSide != civilian) exitWith {};
if((life_safeObj getVariable["safe",-1]) < 1) exitWith {hint "Ce coffre est vide!";};
if((life_safeObj getVariable["inUse",false])) exitWith {hint "Quelqu'un pille deja le coffre.."};
if({side _x == west} count playableUnits < 5) exitWith {hint "Il doit y avoir 5 flics ou plus pour piller le coffre."};
if(!createDialog "Federal_Safe") exitWith {"Probleme d'ouverture de dialog, reportez-le."};
disableSerialization;
ctrlSetText[3501,"Safe Inventory"];
[life_safeObj] call life_fnc_safeInventory;
life_safeObj setVariable["inUse",true,true];
[life_safeObj] spawn
{
	waitUntil {isNull (findDisplay 3500)};
	(_this select 0) setVariable["inUse",false,true];
};