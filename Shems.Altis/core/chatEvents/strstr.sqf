private ["_this", "_needle", "_haystack", "_flags", "_match", "_needleCnt", "_hayItem"];

_needle = [_this select 0, toArray (_this select 0)];
_haystack = [_this select 1, toArray (_this select 1)];
_needleCnt = count (_needle select 1);
_flags = _this select 2; 
_match = false;
_hayItem = 0;

if (count (_needle select 1) > count (_haystack select 1)) exitWith {[false,0]};

if (_needleCnt == count (_haystack select 1)) then
{
	if (!(_flags select 2)) then
	{
		_match = (_needle select 0) == (_haystack select 0);
	} else {
		_match = true;
		for "_i" from 0 to _needleCnt-1 do
		{
			if ((_needle select 1) select _i != (_haystack select 1) select _i) exitWith
			{
				_match = false;
			};
		};
	};
} else {
	private ["_haystackArray", "_currWord", "_space", "_continue", "_loopCnt"];

	_haystackArray = _haystack select 1;
	_currWord = [];
	_space = (toArray(" ")) select 0;
	_loopCnt = if (_flags select 0) then {_needleCnt-1} else {count(_haystackArray)-_needleCnt};
	_continue = true;
	for [{}, {_hayItem <= _loopCnt && !_match}, {_hayItem = _hayItem + 1;}] do
	{
		_match 		= true;
		_continue 	= true;
		if (_flags select 1) then
		{
			if (_hayItem > 0) then
			{
				if (_space != _haystackArray select (_hayItem-1)) exitWith {_match = false; _continue = false;};
			};
			if (_continue && _hayItem < _loopCnt) then
			{
				if (_space != _haystackArray select (_needleCnt+_hayItem)) exitWith {_match = false; _continue = false;};
			};
		};
		
		if (_continue) then
		{
			for "_needlePos" from (_needleCnt-1) to 0 step -1 do
			{
				if (!(_flags select 2)) then
				{
					_currWord set [_needlePos, _haystackArray select (_needlePos + _hayItem)];
				} else {
					if (_haystackArray select (_needlePos+_hayItem) != (_needle select 1) select _needlePos) exitWith {_match = false;};
				};
			};
		
			if (!(_flags select 2)) then
			{
				_match = false;
				if (toString _currWord == _needle select 0) exitWith {_match = true;};
			};
		};
	};
	
	_hayItem = _hayItem - 1;
};

[_match, _hayItem];