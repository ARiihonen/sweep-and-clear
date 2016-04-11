/*
This script is defined as a pre-init function in description.ext, meaning it runs before the map initialises.
*/
#include "logic\preInit.sqf"
#include "logic\activeMods.sqf"

if (isServer) then {
	//Randomizing unit presence variables using caran_randInt and caran_presenceArray
	_players = playersNumber west;
	
	_units_count = if (_players < 8) then { 2; } else {
		if (_players < 10) then { 3; } else {
			if (_players < 12) then { 4; } else {
				if (_players < 14) then { 3; } else {
					4;
				};
			};
		};
	};
	
	_patrol_guys_count = floor (_players/2);
	_extras_count = floor (_players/2);
	_patrols_count = if (_players < 8) then { 1; } else { 2; };
	_camps_count = if (_players < 12) then { 1; } else { 2; };
	_camps = [6, _camps_count] call caran_presenceArray;
	
	camp_1 = [];
	camp_1_patrols = [];
	if (1 in _camps) then {
		camp_1 = [4, _units_count] call caran_presenceArray;
		camp_1_patrols = [2, _patrols_count] call caran_presenceArray;
	};
	
	camp_2 = [];
	camp_2_patrols = [];
	if (2 in _camps) then {
		camp_2 = [4, _units_count] call caran_presenceArray;
		camp_2_patrols = [2, _patrols_count] call caran_presenceArray;
	};
	
	camp_3 = [];
	camp_3_patrols = [];
	if (3 in _camps) then {
		camp_3 = [4, _units_count] call caran_presenceArray;
		camp_3_patrols = [2, _patrols_count] call caran_presenceArray;
	};
	
	camp_4 = [];
	camp_4_patrols = [];
	if (4 in _camps) then {
		camp_4 = [4, _units_count] call caran_presenceArray;
		camp_4_patrols = [2, _patrols_count] call caran_presenceArray;
	};
	
	camp_5 = [];
	camp_5_patrols = [];
	if (5 in _camps) then {
		camp_5 = [4, _units_count] call caran_presenceArray;
		camp_5_patrols = [2, _patrols_count] call caran_presenceArray;
	};
	
	camp_6 = [];
	camp_6_patrols = [];
	if (6 in _camps) then {
		camp_6 = [4, _units_count] call caran_presenceArray;
		camp_6_patrols = [2, _patrols_count] call caran_presenceArray;
	};
	
	patrol_guys = [31, _patrol_guys_count] call caran_presenceArray;
	
	extra_camps = [2,1] call caran_presenceArray;
	extras = [7, _extras_count] call caran_presenceArray;
	
	//Define strings to search for in active addons
	_checkList = [
		"ace_common",
		"asr_ai3_main",
		"task_force_radio",
		"hlcweapons_aks",
		"acre_",
		"rhs_",
		"rhsusf_",
		'mnp_'
	];
	
	//Check mod checklist against active addons
	_checkList call caran_initModList;
	
	if ( "asr_ai3_main" call caran_checkMod ) then {
		call compile preprocessfile "mods\asr.sqf";
	};
};