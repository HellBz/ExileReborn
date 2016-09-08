private ["_positionStart","_positionEnd","_group"];

_civSlow = ["RyanZombieC_man_1slow","RyanZombieC_man_polo_1_Fslow","RyanZombieC_man_polo_2_Fslow","RyanZombieC_man_polo_4_Fslow","RyanZombieC_man_polo_5_Fslow","RyanZombieC_man_polo_6_Fslow","RyanZombieC_man_p_fugitive_Fslow","RyanZombieC_man_w_worker_Fslow","RyanZombieC_man_hunter_1_Fslow"];

_positionStart = [] call JohnO_fnc_findSafeTownPosition;
_positionEnd = [] call JohnO_fnc_findSafeTownPosition;
ryanzombiesdisablescript = true;
if (_positionStart isEqualTo _positionEnd) then
{
	waitUntil 
	{
		_positionStart = [] call JohnO_fnc_findSafeTownPosition;
		_positionEnd = [] call JohnO_fnc_findSafeTownPosition;

	 	!_positionStart isEqualTo _positionEnd
	};
};	

//_mk = createMarker ["Zeds",_positionStart];
//_mk setMarkerType "mil_warning";

_group = createGroup WEST;
_group setFormation "STAG COLUMN";

for "_i" from 0 to 30 do
{
	_unitType = selectRandom _civSlow;
	_unit = _group createUnit [_unitType,_positionStart,[],20,"NONE"];
	_unit setVariable ["JohnO_RoaminAI",time + 1200];
	_unit setVariable ["ExileReborn_hoardMember",1];
	_unit setVariable ["ExileReborn_hoardEnd",_positionEnd];


	_unit setdammage 0.7;
	_unit setspeaker "NoVoice";
	_unit enableFatigue false;
	_unit setbehaviour "CARELESS";
	_unit setunitpos "UP";
	_unit setmimic "safe";

	_facearray = ["RyanZombieFace1", "RyanZombieFace2", "RyanZombieFace3", "RyanZombieFace4", "RyanZombieFace5", "RyanZombieFace6"];
	_face = selectRandom _facearray;
	_unit setface _face;
	removegoggles _unit;

	Event_IdleZombieArray pushBack _unit;
	_unit addMPEventHandler 
	["MPKilled",
		{
			private ["_killer","_currentRespect","_amountEarned","_newRespect","_killSummary"];
			_killed = _this select 0;
			_killer = _this select 1;
			[_killed] joinSilent Event_RadAI_deadGroup;
			_killingPlayer = _killer call ExileServer_util_getFragKiller;
			Event_IdleZombieArray = Event_IdleZombieArray - [_killed]; 
			_currentRespect = _killingPlayer getVariable ["ExileScore", 0];
			_amountEarned = 25;
			_newRespect = _currentRespect + _amountEarned;
			_killingPlayer setVariable ["ExileScore", _newRespect];
			_killSummary = [];
			_killSummary pushBack ["ZOMBIE KILLED", _amountEarned];
			[_killingPlayer, "showFragRequest", [_killSummary]] call ExileServer_system_network_send_to;
			format["setAccountScore:%1:%2", _newRespect, getPlayerUID _killingPlayer] call ExileServer_system_database_query_fireAndForget;
			_killingPlayer call ExileServer_object_player_sendStatsUpdate;	
		}
	];
	_unit addEventHandler
	["FiredNear",
		{
			_this spawn JohnO_zombie_eventOnFiredNear;
		}
	];

	if !(local _unit) then {[_unit, _positionEnd] remoteExecCall ["fnc_RyanZombies_DoMoveLocalized"]} else {_unit domove _positionEnd};

	sleep 0.2;	
};		
