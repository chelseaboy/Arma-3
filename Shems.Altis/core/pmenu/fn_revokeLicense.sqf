private["_display","_curTarget","_Btn1","_Btn2","_Btn3","_Btn4","_Btn5","_Btn6","_Btn7","_Btn8"];
createDialog "revokeLicense_Menu";
disableSerialization;
_curTarget = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull _curTarget) exitWith 
{
	hint "Wrong target!"; 
	closeDialog 0;
};

if(!isPlayer _curTarget && side _curTarget == civilian) exitWith 
{
	hint "Cannot perform this action!"; 
	closeDialog 0;
};

_display = findDisplay 41000;
_Btn1 = _display displayCtrl 41002;
_Btn2 = _display displayCtrl 41003;
_Btn3 = _display displayCtrl 41004;
_Btn4 = _display displayCtrl 41005;
_Btn5 = _display DisplayCtrl 41006;
_Btn6 = _display DisplayCtrl 41007;
_Btn7 = _display DisplayCtrl 41008;
_Btn8 = _display DisplayCtrl 41009;
life_pInact_curTarget = _curTarget;

_Btn1 buttonSetAction "[[10],""life_fnc_removeLicenses"",life_pInact_curTarget,FALSE] spawn life_fnc_MP; closeDialog 0;";
_Btn2 buttonSetAction "[[11],""life_fnc_removeLicenses"",life_pInact_curTarget,FALSE] spawn life_fnc_MP; closeDialog 0;";
_Btn3 buttonSetAction "[[12],""life_fnc_removeLicenses"",life_pInact_curTarget,FALSE] spawn life_fnc_MP; closeDialog 0;";
_Btn4 buttonSetAction "[[13],""life_fnc_removeLicenses"",life_pInact_curTarget,FALSE] spawn life_fnc_MP; closeDialog 0;";
_Btn5 buttonSetAction "[[14],""life_fnc_removeLicenses"",life_pInact_curTarget,FALSE] spawn life_fnc_MP; closeDialog 0;";
_Btn6 buttonSetAction "[[15],""life_fnc_removeLicenses"",life_pInact_curTarget,FALSE] spawn life_fnc_MP; closeDialog 0;";
_Btn7 buttonSetAction "[[16],""life_fnc_removeLicenses"",life_pInact_curTarget,FALSE] spawn life_fnc_MP; closeDialog 0;";
_Btn8 buttonSetAction "[[17],""life_fnc_removeLicenses"",life_pInact_curTarget,FALSE] spawn life_fnc_MP; closeDialog 0;";