/*
This runs on the server machine after objects have initialised in the map. Anything the server needs to set up before the mission is started is set up here.
*/
#include "logic\activeMods.sqf"

//set respawn tickets to 0
[missionNamespace, 1] call BIS_fnc_respawnTickets;
[missionNamespace, -1] call BIS_fnc_respawnTickets;

//set weather
0 setFog [0.5, 0.2, 10];
(2*60*60) setFog [0,0,0];

//set Overwatch name if MNP then Ukko else Overwatch
if ( "mnp_" call caran_checkMod ) then {
	(group ukko) setGroupIDGlobal ["Ukko"];
} else {
	(group ukko) setGroupIDGlobal ["Overwatch"];
};

//Task setting: ["TaskName", locality, ["Description", "Title", "Marker"], target, "STATE", priority, showNotification, true] call BIS_fnc_setTask;
["ClearTask", west, ["Clear the island of any remaining guerrillas", "Clear Island", "Clear"], markerPos "marker_island", "assigned", 1, false, true] call BIS_fnc_setTask;

handleEnding = {
	//Runs end.sqf on everyone. Activate from trigger. For varying mission end states, calculate the correct one here and send it as an argument for end.sqf
	_ending = "";
	switch ( missionNamespace getVariable ["mission_phase", 0] ) do {
		case 1: {
			_ending = "WinOne";
		};
		
		case 2: {
			_ending = "WinBoth";
		};
		
		default {
			_ending = "Lose";
		};
	};
	
	if ( count (allPlayers select { !alive _x }) != 0 ) then {
		
		if ( (count (allPlayers select { !alive _x })) > ( allPlayers/2) ) then {
			_ending = _ending + "Heavy";
		} else {
			_ending = _ending + "Light";
		};
	};
	
	[_ending,"end.sqf"] remoteExec ["BIS_fnc_execVM",0,false];
};

//Updating tasks example: ["TaskName", "STATE", false] call BIS_fnc_taskSetState;
//Custom task update notification: [ ["NotificationName", ["Message"]], "BIS_fnc_showNotification"] call BIS_fnc_MP;
// [ ["NotificationName", ["Message"]], "BIS_fnc_showNotification"] remoteExec [BIS_fnc_MP, west, false];
nextPhase = {
	switch ( missionNamespace getVariable ["mission_phase", 0] ) do {
		case 1: {
			["ClearAnother", "Succeeded", false] call BIS_fnc_taskSetState;
			//[ ["TaskSucceeded", ["Camp cleared"]], "BIS_fnc_showNotification"] call BIS_fnc_MP;
			[ ["TaskSucceeded", ["Camp cleared"]], "BIS_fnc_showNotification"] remoteExec ["BIS_fnc_MP", west, false];
		
			missionNamespace setVariable ["mission_phase", 2, true];
			
			_endMission = [] spawn {
				if ( count (allPlayers select { !alive _x }) == 0 ) then {
					//radio message if no players have died
					[ukko, "rtbGood"] remoteExec ["sideRadio", 0, false];
				} else {
					//radio message if some players have died
					[ukko, "rtbBad"] remoteExec ["sideRadio", 0, false];
				};
				
				sleep 2;
				
				call handleEnding;
			};
		};
		
		default {
			["ClearTask", "Succeeded", false] call BIS_fnc_taskSetState;
			//[ ["TaskSucceeded", ["Island cleared"]], "BIS_fnc_showNotification"] call BIS_fnc_MP;
			[ ["TaskSucceeded", ["Island cleared"]], "BIS_fnc_showNotification"] remoteExec ["BIS_fnc_MP", west, false];
			
			missionNamespace setVariable ["mission_phase", 1, true];
			
			_newTasking = [] spawn {
			
				if ( count (allPlayers select { !alive _x }) == 0 ) then {
				
					//radio message if no players have died
					[ukko, "newTask"] remoteExec ["sideRadio", 0, false];
					
					sleep 2;
					
					["ClearAnother", west, ["SIGINT has picked up communications between the guerrilla fighters on the island and another group. Continue the operation and clear the other camp.", "Clear New Camp", "Clear"], markerPos "marker_camps", "assigned", 2, false, true] call BIS_fnc_setTask;
					//[ ["TaskAssigned", ["Clear New Camp"]], "BIS_fnc_showNotification"] call BIS_fnc_MP;
					[ ["TaskAssigned", ["Clear new camp"]], "BIS_fnc_showNotification"] remoteExec ["BIS_fnc_MP", west, false];
					
					"marker_camps" setMarkerAlpha 1;
				
				} else {
					
					//radio message if some players have died
					[ukko, "rtbBad"] remoteExec ["sideRadio", 0, false];
					
					sleep 2;
					
					call handleEnding;
				};
			};
		};
	};
};

//client inits wait for serverInit to be true before starting, to make sure all variables the server sets up are set up before clients try to refer to them (which would cause errors)
serverInit = true;
publicVariable "serverInit";