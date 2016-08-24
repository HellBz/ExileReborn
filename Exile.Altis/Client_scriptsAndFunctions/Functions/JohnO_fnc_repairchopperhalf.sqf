/**
 * ExileClient_object_vehicle_repair
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_vehicle","_availableHitpoints","_fixable","_equippedMagazines"];
_vehicle = _this select 0;
/*if (ExileClientPlayerIsInCombat) exitWith
{
	["RepairFailedWarning", ["You are in combat!"]] call ExileClient_gui_notification_event_addNotification;
};*/
if (vehicle player isEqualTo _vehicle) exitWith 
{
	[
	"InfoTitleAndText", 
	["No..", "Are you serious?"]
] call ExileClient_gui_toaster_addTemplateToast;
};
_availableHitpoints = (getAllHitPointsDamage _vehicle) select 0;
{
	if((_vehicle getHitPointDamage _x) > 0)exitWith
	{
		_fixable = "potato";
	};
}
forEach _availableHitpoints;

if (isNil "_fixable") exitWith 
{
	[
		"InfoTitleAndText", 
		["Repair Info", "This vehicle is already fully repaired"]
	] call ExileClient_gui_toaster_addTemplateToast;
}; 
if (!local _vehicle) then
{
	[
		"InfoTitleAndText", 
		["Repair Info", "Get in the driver seat first"]
	] call ExileClient_gui_toaster_addTemplateToast;
}
else 
{
	_equippedMagazines = magazines player;
	if ("Exile_Item_Foolbox" in _equippedMagazines) then
	{	
		if ("Exile_Item_Wrench" in _equippedMagazines) then
		{
			if ("Exile_Item_DuctTape" in _equippedMagazines) then
			{
				if ("Exile_Item_JunkMetal" in _equippedMagazines) then
				{				
					player playActionNow "Medic";
						
					disableSerialization;
					("ExileActionProgressLayer" call BIS_fnc_rscLayer) cutRsc ["RscExileActionProgress", "PLAIN", 1, false];

					_startTime = diag_tickTime;
					_duration = 12;
					_sleepDuration = _duration / 100;
					_progress = 0;

					_display = uiNamespace getVariable "RscExileActionProgress";   
					_label = _display displayCtrl 4002;
					_label ctrlSetText "0%";
					_progressBarBackground = _display displayCtrl 4001;  
					_progressBarMaxSize = ctrlPosition _progressBarBackground;
					_progressBar = _display displayCtrl 4000;  
					_progressBar ctrlSetPosition [_progressBarMaxSize select 0, _progressBarMaxSize select 1, 0, _progressBarMaxSize select 3];
					_progressBar ctrlSetBackgroundColor [0, 0.78, 0.93, 1];
					_progressBar ctrlCommit 0;
					_progressBar ctrlSetPosition _progressBarMaxSize; 
					_progressBar ctrlCommit _duration;

					disableUserInput true;
					while {_progress < 1} do
					{	
						_label ctrlSetText format["%1%2", round (_progress * 100), "%"];
						uiSleep _sleepDuration; 

						_progress = ((diag_tickTime - _startTime) / _duration) min 1;
						player playActionNow "Medic";
					};
					disableUserInput false;

					_progressBarColor = [0.7, 0.93, 0, 1];
					_progressBar ctrlSetBackgroundColor _progressBarColor;

					_progressBar ctrlSetPosition _progressBarMaxSize;
					_progressBar ctrlCommit 0;

					("ExileActionProgressLayer" call BIS_fnc_rscLayer) cutFadeOut 2;
					if (_vehicle isKindOf "car")  then
					{	
						{
							_vehicle setHitPointDamage [_x,0];
						}	forEach _repairable;
					}						
					else
					{
						_vehicle setDamage + damage _vehicle - 0.2;
					};	
					player removeItem "Exile_Item_DuctTape";
					player removeItem "Exile_Item_JunkMetal";
					[
						"InfoTitleAndText", 
						["Repair Info", "You have partially repaired the body of this vehicle"]
					] call ExileClient_gui_toaster_addTemplateToast;								
				}
				else
				{
					[
						"InfoTitleAndText", 
						["Repair Info", "You need junkmetal to do that"]
					] call ExileClient_gui_toaster_addTemplateToast;
				};
			}
			else 
			{
				[
					"InfoTitleAndText", 
					["Repair Info", "You need duct tape to do that"]
				] call ExileClient_gui_toaster_addTemplateToast;
			};
		}
		else
		{
			[
				"InfoTitleAndText", 
				["Repair Info", "You need a wrench"]
			] call ExileClient_gui_toaster_addTemplateToast;
		};	
	}
	else
	{
		[
			"InfoTitleAndText", 
			["Repair Info", "You need a tool box"]
		] call ExileClient_gui_toaster_addTemplateToast;
	};
	
};
true