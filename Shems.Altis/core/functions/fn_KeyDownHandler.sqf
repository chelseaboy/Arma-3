private ["_handled","_shift","_alt","_code","_ctrl","_alt","_ctrlKey","_veh","_locked","_interactionKey","_mapKey","_interruptionKeys","_player"];
_ctrl = _this select 0;
_code = _this select 1;
_shift = _this select 2;
_ctrlKey = _this select 3;
_alt = _this select 4;
_speed = speed cursorTarget;
_handled = false;
_player = player;
_interactionKey = if(count (actionKeys "User10") == 0) then {219} else {(actionKeys "User10") select 0};
_mapKey = actionKeys "ShowMap" select 0;
_interruptionKeys = [17,30,31,32];

switch (_code) do
{
	case _mapKey:
	{
		switch (playerSide) do 
		{
			case west: {if(!visibleMap) then {[] spawn life_fnc_copMarkers;}};
			case independent: {if(!visibleMap) then {[] spawn life_fnc_medicMarkers;}};
			case civilian: {if(!visibleMap) then {[] spawn life_fnc_gangMarkers;}};
		};
	};

	case _interactionKey:
	{
		if(!life_action_inUse) then 
		{
			[] spawn 
			{
				private "_handle";
				_handle = [] spawn life_fnc_keyDownHandler;
				waitUntil {scriptDone _handle};
				life_action_inUse = false;
			};
		};
	};

    case 1:
	{
		if(_ctrlKey)  then 
		{
			SOCK_fnc_updateRequest;
			diag_log format ["%1 utilise CTRL + ESC pour se déconnecter",_player getVariable["realname",name _player]];
			[[1,format["%1 utilise CTRL + ESC pour se déconnecter",_player getVariable["realname",name _player]]],"life_fnc_broadcast",nil,false] call life_fnc_MP;
			SOCK_fnc_updateRequest;
		};
	};

	case 7:
	{
		if(!_alt && !_ctrlKey) then 
		{
			[] spawn life_fnc_activateNitro;
		};
	};

	case 15:
	{
		if(!_alt && !_ctrlKey) then
		{
			if (vehicle player == player && !(player getVariable ["restrained", false]) && !(player getVariable ["Escorting", false])) then 
			{
				if (player getVariable ["playerSurrender",false]) then 
				{
					player setVariable ["playerSurrender",false,true];
				} else {
					[] spawn life_fnc_surrender;
				};
			};
			_handled = true;
		};
	};

	case 19:
	{
		if(_shift) then {_handled = true;};
		switch (playerSide) do
		{
			case west:
			{
				if(_shift && !(player getVariable["restrained",false]) && !isNull cursorTarget && cursorTarget isKindOf "Man" && (isPlayer cursorTarget) && (side cursorTarget in [west,civilian,independent]) && alive cursorTarget && cursorTarget distance player < 3.5 && !(cursorTarget getVariable "Escorting") && !(cursorTarget getVariable "restrained") && !life_knockout && speed cursorTarget < 1) then
				{
					[] call life_fnc_copRestrainAction;
				};
			};

			case civilian:
			{
				if(_shift && !(player getVariable["restrained",false]) && !isNull cursorTarget && cursorTarget isKindOf "Man" && (isPlayer cursorTarget) && (side cursorTarget in [west,civilian,independent]) && alive cursorTarget && cursorTarget distance player < 3.5 && !(cursorTarget getVariable "Escorting") && !(cursorTarget getVariable "restrained") && !life_knockout && speed cursorTarget < 1) then
				{
					[] call life_fnc_civRestrainAction;
				};
			};

			case independent:
			{
				if(_shift && !(player getVariable["restrained",false]) && !isNull cursorTarget && cursorTarget isKindOf "Man" && (isPlayer cursorTarget) && (side cursorTarget in [west,civilian,independent]) && alive cursorTarget && cursorTarget distance player < 3.5 && !(cursorTarget getVariable "Escorting") && !(cursorTarget getVariable "restrained") && !life_knockout && speed cursorTarget < 1) then
				{
					[] call life_fnc_medRestrainAction;
				};
			};
		};
	};

	case 20:
	{
		if(!_alt && !_ctrlKey) then
		{
			if(vehicle player != player && alive vehicle player) then
			{
				if((vehicle player) in life_vehicles) then
				{
					[vehicle player] call life_fnc_openInventory;
				};
			} else {
				if((
					cursorTarget isKindOf "Land_Wreck_Traw_F" OR 
					cursorTarget isKindOf "Land_Wreck_Traw2_F" OR 
					cursorTarget isKindOf "Car" OR 
					cursorTarget isKindOf "Air" OR 
					cursorTarget isKindOf "Ship" OR 
					cursorTarget isKindOf "House_F"
				) && player distance cursorTarget < 7 && vehicle player == player && alive cursorTarget) then
				{
					if(cursorTarget in life_vehicles OR {!(cursorTarget getVariable ["locked",true])}) then
					//if(cursorTarget in life_vehicles) then
					{
						[cursorTarget] call life_fnc_openInventory;
					};
					if (cursorTarget isKindOf "Land_Wreck_Traw_F" OR cursorTarget isKindOf "Land_Wreck_Traw2_F") then 
					{
						[cursorTarget] spawn life_fnc_openInventory;
					};
				} else {
					if((typeOf cursorTarget in 
					[
						"Land_Portable_generator_F",
						"Box_NATO_AmmoVeh_F",
						"Box_East_AmmoVeh_F",
						"Box_IND_AmmoVeh_F",
						"Land_Cargo20_blue_F",
						"Land_Cargo20_brick_red_F",
						"Land_Cargo20_cyan_F",
						"Land_Cargo20_grey_F",
						"Land_Cargo20_light_blue_F",
						"Land_Cargo20_light_green_F",
						"Land_Cargo20_military_green_F",
						"Land_Cargo20_orange_F",
						"Land_Cargo20_red_F",
						"Land_Cargo20_sand_F",
						"Land_Cargo20_white_F",
						"Land_Cargo20_yellow_F",
						"Land_TentA_F",
						"Land_TentDome_F"
					]) && player distance cursorTarget < 7 && alive cursorTarget) then
					{
						[cursorTarget] call life_fnc_openInventory;
					};
				};
			};
		};
	};

	case 21:
	{
		if((_code in (actionKeys "SelectAll") || _code in (actionKeys "ForceCommandingMode"))) then 
		{
			[] call life_fnc_p_openMenu;
		};
	};

	case 22:
	{
		if(!_alt && !_ctrlKey) then 
		{
			if(vehicle player == player) then 
			{
				_veh = cursorTarget;
			} else {
				_veh = vehicle player;
			};
			if(_veh isKindOf "House_F" && playerSide == civilian) then 
			{
				if(_veh in life_vehicles && player distance _veh < 8) then 
				{
					_door = [_veh] call life_fnc_nearestDoor;
					if(_door == 0) exitWith {hint "Vous n'êtes pas à proximité d'une porte!"};
					_locked = _veh getVariable [format["bis_disabled_Door_%1",_door],0];
					if(_locked == 0) then 
					{
						_veh setVariable[format["bis_disabled_Door_%1",_door],1,true];
						_veh animate [format["door_%1_rot",_door],0];
						systemChat "Vous avez fermé votre maison.";
					} else {
						_veh setVariable[format["bis_disabled_Door_%1",_door],0,true];
						_veh animate [format["door_%1_rot",_door],1];
						systemChat "Vous avez ouvert votre maison.";
					};
				};
			} else {
				_locked = locked _veh;
				_doors = ["door_back_R","door_back_L","door_R","door_L","Door_rear","Door_LM","Door_RM","Door_LF","Door_RF","Door_LB","Door_RB"];
				if(_veh in life_vehicles && player distance _veh < 8) then
				{
					if(_locked == 2) then
					{
						if(local _veh) then
						{
							_veh lock 0;
							{
								_veh animateDoor [_x,1];
							} forEach _doors;
						} else {
							[[_veh,0], "life_fnc_lockVehicle",_veh,false] call life_fnc_MP;
							{
								_veh animateDoor [_x,1];
							} forEach _doors;
						};
						hint composeText [image "icons\unlock.paa"," Véhicule ouvert"];
						_veh say3D "Beep";
					} else {
						if(local _veh) then
						{
							_veh lock 2;
							{
								_veh animateDoor [_x,0];
							} forEach _doors;
						} else {
							[[_veh,2], "life_fnc_lockVehicle",_veh,false] call life_fnc_MP;
							{
								_veh animateDoor [_x,0];
							} forEach _doors;
						};
						hint composeText [image "icons\lock.paa"," Véhicule fermé"];
						_veh say3D "BeepBeep";
					};
				};
			};
		};
	};

	case 33:
	{
		if (!_shift) then
		{
			if(playerSide == west && vehicle player != player && !life_siren_active && ((driver vehicle player) == player)) then
			{
				[] spawn
				{
					life_siren_active = true;
					sleep 4.7;
					life_siren_active = false;
				};
				_veh = vehicle player;
				if(isNil {_veh getVariable "siren"}) then 
				{
					_veh setVariable["siren",false,true];
				};

				if((_veh getVariable "siren")) then
				{
					titleText ["Sirènes Eteintes","PLAIN"];
					_veh setVariable["siren",false,true];
				} else {
					titleText ["Sirènes Activés","PLAIN"];
					_veh setVariable["siren",true,true];
					[[_veh],"life_fnc_copSiren",nil,true] call life_fnc_MP;
                };
            };
        };
    };

	case 34:
	{
		if(_shift) then {_handled = true;};
		if(_shift && !isNull cursorTarget && cursorTarget isKindOf "Man" && (isPlayer cursorTarget) && alive cursorTarget && cursorTarget distance player < 4 && speed cursorTarget < 1 && !(cursorTarget getVariable "restrained")) then
		{
			if((animationState cursorTarget) != "Incapacitated" && (currentWeapon player == primaryWeapon player || currentWeapon player == handgunWeapon player) && currentWeapon player != "" && !life_knockout && !(player getVariable["Restrained",false]) && !life_istazed) then
			{
				[cursorTarget] spawn life_fnc_knockoutAction;
				if("ItemRadio" in assignedItems cursorTarget) then 
				{
					cursorTarget removeWeapon "ItemRadio";
					hint "Un téléphone est tombé de la poche de cette personne.";
					_defenceplace1 = "Item_ItemRadio" createVehicle (player modelToWorld[0,0,0]);
				//} else {
					//hint "La personne que vous avez assomé n'as pas de téléphone.";
				};
			};
		};
	};

	case 35:
	{
		if(_shift && !_ctrlKey && (currentWeapon player == "")) then 
		{
			[0] call life_fnc_holsterHandgun;
		};

		if(!_shift && _ctrlKey && (currentWeapon player != "")) then 
		{
			[1] call life_fnc_holsterHandgun;
		};	
	};

	case 38: 
	{
		if(_shift && playerSide != civilian) then 
		{
			if(vehicle player != player && (typeOf vehicle player) in ["C_Offroad_01_F","B_MRAP_01_F","C_SUV_01_F"]) then 
			{
				if(!isNil {vehicle player getVariable "lights"}) then 
				{
					[vehicle player] call life_fnc_sirenLights;
					_handled = true;
				};
			};
		};
	};

	case 47:
	{
		if(playerSide != west && (player getVariable "restrained") OR (player getVariable "transporting")) then {_handled = true;};
	};

	case 57:
	{
		if(animationState player != "AovrPercMrunSrasWrflDf" && {isTouchingGround player} && {stance player == "STAND"} && {speed player > 2}) then 
		{
			[player,true] spawn life_fnc_jumpFnc;
			[[player,false],"life_fnc_jumpFnc",nil,FALSE] call life_fnc_MP;
			_handled = true;
		};
	};
	
	case 62:
	{
		if(_alt && !_shift) then 
		{
			SOCK_fnc_updateRequest;
			diag_log format ["%1 utilise ALT+F4 pour se déconnecter",_player getVariable["realname",name _player]];
			[[1,format["%1 utilise ALT+F4 pour se déconnecter",_player getVariable["realname",name _player]]],"life_fnc_broadcast",nil,false] call life_fnc_MP;
			SOCK_fnc_updateRequest;
		};
	};
	
	case 86:
	{
		if((!life_action_inUse) && (vehicle player == player) ) then
		{
			{
				_str = [_x] call life_fnc_varToStr;
				_val = missionNameSpace getVariable _x;
				if(_val > 0 ) then
				{
					if( _str == "Pickaxe" || _str == "pickaxe" ) then
					{
						[] spawn life_fnc_pickAxeUse;
					};
				};
			} foreach life_inv_items;
		}
	};

	case 181:
	{
		if (!_alt && !_ctrlKey && playerSide == west) then
		{
			[] call life_fnc_radar;
		};
	}; 

    case 211:
	{
		if(_ctrlKey && _alt)  then 
		{
			SOCK_fnc_updateRequest;
			diag_log format ["%1 utilise CTRL + ALT + DEL pour se déconnecter",_player getVariable["realname",name _player]];
			[[1,format["%1 utilise CTRL + ALT + DEL  pour se déconnecter",_player getVariable["realname",name _player]]],"life_fnc_broadcast",nil,false] call life_fnc_MP;
			SOCK_fnc_updateRequest;
		};
	};
};

if(life_action_inUse) exitWith 
{
	if(!life_interrupted && _code in _interruptionKeys) then {life_interrupted = true;};
	_handled;
};

if((_code in (actionKeys "GetOver") || _code in (actionKeys "salute")) && {(player getVariable ["restrained",false])}) exitWith {true;};
if((_code in (actionKeys "SelectAll") || _code in (actionKeys "ForceCommandingMode"))) then {_handled = true;};
if (_code in (actionKeys "NextAction") || _code in (actionKeys "PrevAction")) then 
{
	if (!life_show_actions) then
	{
		[] spawn life_fnc_enableActions;
	};
};

if (life_brokenLeg && (_code in (actionKeys "MoveUp") || _code in (actionKeys "MoveDown") || _code in (actionKeys "Stand") || _code in (actionKeys "Crouch"))) then
{
	systemChat "Votre jambe est fracturé.";
	_handled = true;
};

if(count (actionKeys "User10") != 0 && {(inputAction "User10" > 0)}) exitWith 
{
	if(!life_action_inUse) then 
	{
		[] spawn 
		{
			private "_handle";
			_handle = [] spawn life_fnc_keyDownHandler;
			waitUntil {scriptDone _handle};
			life_action_inUse = false;
		};
	};
	true;
};

_handled;