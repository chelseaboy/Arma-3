KRON_StrToArray = 
{
	private["_in","_i","_arr","_out"];
	_in = _this select 0;
	_arr = toArray(_in);
	_out = [];
	for "_i" from 0 to (count _arr)-1 do 
	{
		_out=_out+[toString([_arr select _i])];
	};
	_out
};

KRON_StrLeft = 
{
	private["_in","_len","_arr","_out"];
	_in = _this select 0;
	_len = (_this select 1)-1;
	_arr = [_in] call KRON_StrToArray;
	_out = "";
	if (_len>=(count _arr)) then 
	{
		_out = _in;
	} else {
		for "_i" from 0 to _len do 
		{
			_out=_out + (_arr select _i);
		};
	};
	_out
};

KRON_StrLen = 
{
	private["_in","_arr","_len"];
	_in = _this select 0;
	_arr = [_in] call KRON_StrToArray;
	_len = count (_arr);
	_len
};

KRON_StrRight = 
{
	private["_in","_len","_arr","_i","_out"];
	_in = _this select 0;
	_len = _this select 1;
	_arr = [_in] call KRON_StrToArray;
	_out = "";
	if (_len>(count _arr)) then 
	{
		_len=count _arr
	};

	for "_i" from ((count _arr)-_len) to ((count _arr)-1) do 
	{
		_out=_out + (_arr select _i);
	};
	_out
};
	
KRON_StrMid = 
{
	private["_in","_pos","_len","_arr","_i","_out"];
	_in = _this select 0;
	_pos = abs(_this select 1);
	_arr = [_in] call KRON_StrToArray;
	_len = count(_arr);
	if ((count _this)>2) then 
	{
		_len=(_this select 2)
	};
	_out="";
	if ((_pos+_len) > = (count _arr)) then 
	{
		_len = (count _arr)-_pos
	};
	if (_len>0) then 
	{
		for "_i" from _pos to (_pos + _len-1) do 
		{
			_out = _out + (_arr select _i);
		};
	};
	_out
};

KRON_StrIndex = 
{
	private["_hay","_ndl","_lh","_ln","_arr","_tmp","_i","_j","_out"];
	_hay = _this select 0;
	_ndl = _this select 1;
	_out = -1;
	_i = 0;
	if (_hay == _ndl) exitWith {0};
	_lh = [_hay] call KRON_StrLen;
	_ln = [_ndl] call KRON_StrLen;
	if (_lh < _ln) exitWith {-1};
	_arr = [_hay] call KRON_StrToArray;
	for "_i" from 0 to (_lh-_ln) do 
	{
		_tmp = "";
		for "_j" from _i to (_i+_ln-1) do 
		{
			_tmp=_tmp + (_arr select _j);
		};
		if (_tmp==_ndl) exitWith {_out=_i};
	};
	_out
};

KRON_StrInStr = 
{
	private["_out"];
	_in = _this select 0;
	_out = if (([_this select 0,_this select 1] call KRON_StrIndex)==-1) then {false} else {true};
 	_out
};

KRON_Replace = 
{
	private["_str","_old","_new","_out","_tmp","_jm","_la","_lo","_ln","_i"];
	_str = _this select 0;
	_arr = toArray(_str);
	_la = count _arr;
	_old = _this select 1;
	_new = _this select 2;
	_na = [_new] call KRON_StrToArray;
	_lo = [_old] call KRON_StrLen;
	_ln = [_new] call KRON_StrLen;
	_out = "";
	for "_i" from 0 to (count _arr) -1 do 
	{
		_tmp = "";
		if (_i <= _la-_lo) then 
		{
			for "_j" from _i to (_i + _lo-1) do 
			{
				_tmp = _tmp + toString([_arr select _j]);
			};
		};
		if (_tmp==_old) then 
		{
			_out = _out+_new;
			_i = _i+_lo-1;
		} else {
			_out = _out+toString([_arr select _i]);
		};
	};
	_out
};

KRON_StrUpper = 
{
	private["_in","_out"];
	_in = _this select 0;
	_out = toUpper(_in);
	_out
};

KRON_StrLower = 
{
	private["_in","_out"];
	_in = _this select 0;
	_out = toLower(_in);
	_out
};

KRON_ArrayToUpper = 
{
	private["_in","_i","_e","_out"];
	_in = _this select 0;
	_out = [];
	if ((count _in)>0) then 
	{
		for "_i" from 0 to (count _in)-1 do 
		{
			_e = _in select _i;
 			if (typeName _e == "STRING") then 
			{
 				_e = toUpper(_e);
 			};
			_out set [_i,_e];
		};
	};
	_out
};

KRON_Compare = 
{
	private["_k","_n","_s","_i","_c","_t","_s1","_s2","_l1","_l2","_l"];
	_k = [_this,"CASE"] call KRON_findFlag;
	_n = 0;
	_s = 0;
	for "_i" from 0 to 1 do 
	{
		_t=_this select _i;
		switch (typeName _t) do 
		{
			case "SCALAR": {_n=1};
			case "BOOL": {_this set [_i,str(_t)]};
			case "SIDE": {_this set [_i,str(_t)]};
			case "STRING": {if !(_k) then {_this=[_this] call KRON_ArrayToUpper}};
			default {_n=-1};
		};
	};
	_s1 = _this select 0;
	_s2 = _this select 1;
	if (_n != 0) exitWith 
	{
		if (_n == 1) then 
		{
			if (_s1<_s2) then {_s=-1} else {if (_s1>_s2) then {_s=1}};
		};
		_s	
	};
	_s1 = toArray(_s1);
	_s2 = toArray(_s2);
	_l1 = count _s1;
	_l2 = count _s2;
	_l=if (_l1<_l2) then {_l1} else {_l2};
	for "_i" from 0 to _l-1 do 
	{
		if ((_s1 select _i)<(_s2 select _i)) then 
		{
			_s = -1; 
			_i = _l;
		} else {
			if ((_s1 select _i)>(_s2 select _i)) then 
			{
				_s = 1;
				_i = _l;
			};
		};
	};
	if (_s==0) then 
	{
		if (_l1<_l2) then 
		{
			_s = -1;
		} else {
			if (_l1>_l2) then {_s=1};
		};
	};
	_s
};

KRON_ArraySort = 
{
	private["_a","_d","_k","_s","_i","_vo","_v1","_v2","_j","_c","_x"];
	_a = +(_this select 0);
	_d = if ([_this,"DESC"] call KRON_findFlag) then {-1} else {1};
	_k = if ([_this,"CASE"] call KRON_findFlag) then {"CASE"} else {"nocase"};
	_s = -1;
	if (typeName (_a select 0)=="ARRAY") then 
	{
		_s = 0;
		if (((count _this)>1) && (typeName (_this select 1)=="SCALAR")) then 
		{
			_s=_this select 1;
		};
	};
	for "_i" from 0 to (count _a)-1 do 
	{
		_vo = _a select _i;
		_v1 = _vo;
		if (_s>-1) then {_v1=_v1 select _s};
		_j = 0;
		for [{_j=_i-1},{_j>=0},{_j=_j-1}] do 
		{
			_v2 = _a select _j;
			if (_s>-1) then {_v2=_v2 select _s};
			_c = [_v2,_v1,_k] call KRON_Compare;
			if (_c !=_d) exitWith {};
			_a set [_j+1,_a select _j];
		};
		_a set [_j+1,_vo];
	};
	_a
};

KRON_findFlag = 
{
	private["_in","_flg","_arr","_out"];
	_in = _this select 0;
	_flg = toUpper(_this select 1);
	_arr = [_in] call KRON_ArrayToUpper;
	_out = _flg in _arr;
	_out
};

KRON_getArg = 
{
	private["_in","_flg","_fl","_def","_arr","_i","_j","_as","_aa","_org","_p","_out"];
	_in = _this select 0;
	_flg = toUpper(_this select 1);
	_fl = [_flg] call KRON_StrLen;
	_out = "";
	if ((count _this)>2) then {_out=_this select 2};
	_arr = [_in] call KRON_ArrayToUpper;
	if ((count _arr)>0) then 
	{
		for "_i" from 0 to (count _in)-1 do 
		{
			_as = _arr select _i;
			if (typeName _as == "STRING") then 
			{
				_aa = [_as] call KRON_StrToArray;
				_p = _aa find ":";
				if (_p == _fl) then 
				{
					if (([_as,_fl] call KRON_StrLeft) == _flg) then 
					{
						_org = _in select _i;
						_out = [_org,_p+1] call KRON_StrMid;
					};
				};
			};
		};
	};
 	_out
};

KRON_getArgRev = 
{
	private["_in","_flg","_fl","_def","_arr","_i","_j","_as","_aa","_org","_p","_out"];
	_in = _this select 0;
	_flg = toUpper(_this select 1);
	_fl = [_flg] call KRON_StrLen;
	_out = "";
	if ((count _this)>2) then {_out=_this select 2};
	_arr = [_in] call KRON_ArrayToUpper;
	if ((count _arr) > 0) then 
	{
		for "_i" from 0 to (count _in)-1 do 
		{
			_as = _arr select _i;
			if (typeName _as == "STRING") then 
			{
				_aa = [_as] call KRON_StrToArray;
				_p = _aa find ":";
				if (_p+1==(count _aa)-_fl) then 
				{
					if (([_as,_p+1] call KRON_StrMid)==_flg) then 
					{
						_org = _in select _i;
						_out=[_org,_p] call KRON_StrLeft;
					};
				};
			};
		};
	};
 	_out
};

MAC_fnc_switchMove = 
{
    private["_object","_anim"];
    _object = _this select 0;
    _anim = _this select 1;
    _object switchMove _anim;
};

SHEMS_playerByName = 
{
	_name = [_this,0,"",[""]] call BIS_fnc_param;
	_unit = objNull;
	{
		if(name _x == _name) then 
		{
			_unit = _x;
		};
	} forEach playableUnits;
	_unit
};

SHEMS_playerByUID = 
{
	_pid = [_this,0,"",[""]] call BIS_fnc_param;
	_unit = objNull;
	{
		if(getPlayerUID _x == _pid) then 
		{
			_unit = _x;
		};
	} forEach playableUnits;
	_unit
};

SHEMS_isPlayerUIDActive = 
{
	_pid = [_this,0,"",[""]] call BIS_fnc_param;
	_unit = [_pid] call SHEMS_playerByUID;
	_on = true;
	if(isNull _unit) then 
	{
		_on = false;
	};
	_on
};

SHEMS_isPlayerNameActive = 
{
	_name = [_this,0,"",[""]] call BIS_fnc_param;
	_unit = [_name] call SHEMS_playerByName;
	_on = true;
	if(isNull _unit) then 
	{
		_on = false;
	};
	_on
};

SHEMS_percentChance = 
{
	_percent = [_this,0,0,[0]] call BIS_fnc_param;
	_dice = random(100);
	_ret = false;
	if(_dice <= _percent) then 
	{
		_ret = true;
	};
	_ret
};

SHEMS_closeAllDialogs = 
{
	while {dialog} do 
	{
		closeDialog 0;
		sleep 0.1;
	};
};

SHEMS_stringContains = 
{
	_text = [_this,0,"",[""]] call BIS_fnc_param;
	_plainText = [97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,48,49,50,51,52,53,54,55,56,57,32];
	_arr = toArray _text;
	_ok = true;
	{
		if(!(_x in _plainText)) then 
		{
			_ok = false;
		};
	} forEach _arr;
	_ok
};

SHEMS_compileFinal = 
{   
    private ["_var","_ns","_code","_arr"];
    _var = [_this,0,"",[""]] call BIS_fnc_param;
    _ns = [_this,1,missionNamespace,[missionNamespace]] call BIS_fnc_param;
    _code = _ns getVariable [_var, 0];
    if (typeName _code != typeName {}) exitWith {false};
    _arr = toArray str _code;
    _arr set [0,32];
    _arr set [count _arr - 1,32];
    _code = compileFinal toString _arr;
    _ns setVariable [_var, _code];
    true
};

SHEMS_upperFirst = 
{
	_item = [_this,0,"",[""]] call BIS_fnc_param;
	_charArr = toArray(_item);
	_firstChar = _charArr select 0;
	_firstChar = toString ([_firstChar]);
	_firstChar = toUpper (_firstChar);
	_firstChar = toArray (_firstChar);
	_charArr set[0,(_firstChar select 0)];
	_str = toString (_charArr);
	_str;
};