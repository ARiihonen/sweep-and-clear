#include "..\logic\gear.sqf"
#include "..\logic\activeMods.sqf";

//Get player class and make sure it's all uppercase since BI classnames are super inconsistent
_class = typeOf player;
_class = toUpper _class;

//Remove all gear. Remove if only adding items or swapping non-containers
if ("mnp_" call caran_checkMod) then {
	player call caran_clearInventory;

	//Define default gear types. Leave as is if no change from default unit required (or remove both from here and from calls at the end of this file)
	_uniform = "MNP_CombatUniform_Fin_A";
	_vest = "MNP_Vest_FIN_2";
	_backpack = "";
	_headwear = ["MNP_Helmet_FIN_T",""];
	if ("rhs_" call caran_checkMod) then {
		_headwear set [1, "rhs_ess_black"];
	};

	_items = [ ["SmokeShell", 2, "Vest"], ["HandGrenade", 1, "Vest"], ["SmokeShellBlue", 1, "Vest"]];
	//Medical. ACE if active, vanilla if not
	if ( "ace_" call caran_checkMod ) then {
		{ _items pushback [_x, 4, "Uniform"]; } forEach ["ACE_morphine", "ACE_epinephrine"];
		{ _items pushback [_x, 8, "Uniform"]; } forEach ["ACE_elasticBandage", "ACE_packingBandage"];
		_items pushback ["ACE_tourniquet", 1, "Uniform"];
		_items pushback ["ACE_MapTools", 1, "Uniform"];
	} else {
		_items pushback ["FirstAidKit", 2, "Uniform"];
	};
	
	_link_items = ["ItemMap", "ItemCompass", "ItemWatch", "ItemRadio"];
	_item_weapons = [];

	_primary_weapon = "arifle_MX_Black_F";
	_primary_weapon_items = ["optic_Aco"];
	_primary_ammo_array = ["30Rnd_65x39_caseless_mag", 8, "Vest"];
	if ("hlc" call caran_checkMod) then {
		_primary_weapon = "hlc_rifle_RK62";
		_primary_weapon_items = [];
		_primary_ammo_array = ["hlc_30Rnd_762x39_b_ak", 8, "Vest"];
	} else {
		if ("rhs_" call caran_checkMod) then {
			_primary_weapon = "rhs_weap_ak103_npz";
			_primary_weapon_items = ["rhsusf_acc_eotech_552", "rhs_acc_dtk3"];
			_primary_ammo_array = ["rhs_30Rnd_762x39mm", 8, "Vest"];
		};
	};

	_handgun = "hgun_P07_F";
	_handgun_items = [];
	_handgun_ammo_array = ["16Rnd_9x21_Mag", 2, "Vest"];
	if ("rhs_" call caran_checkMod) then {
		_handgun = "rhsusf_weap_glock17g4";
		_handgun_items = [];
		_handgun_ammo_array = ["rhsusf_mag_17Rnd_9x19_JHP", 2, "Vest"];
	};

	switch _class do {
		case "B_SOLDIER_SL_F": {
			
			switch _primary_weapon do {
				case "rhs_weap_ak103_npz": {
					_primary_weapon_items set [0, "rhsusf_acc_ACOG3"];
				};
				
				case "arifle_MX_Black_F": {
					_primary_weapon_items set [0, "optic_Hamr"];
					_primary_ammo_array = ["30Rnd_65x39_caseless_mag", 4, "Vest"];
					_items pushBack ["30Rnd_65x39_caseless_mag_Tracer", 4, "Vest"];
				};
				
				case "hlc_rifle_RK62": {
					_primary_ammo_array = ["hlc_30Rnd_762x39_b_ak", 4, "Vest"];
					_items pushBack ["hlc_30Rnd_762x39_t_ak", 4, "Vest"];
				};
			};
			
			_item_weapons pushBack "Binocular";
			_link_items pushBack "ItemGPS";
		};
		
		case "B_SOLDIER_TL_F": {
			switch _primary_weapon do {
				case "rhs_weap_ak103_npz": {
					_primary_weapon_items set [0, "rhsusf_acc_ACOG3"];
				};
				
				case "arifle_MX_Black_F": {
					_primary_weapon_items set [0, "optic_Hamr"];
					_primary_ammo_array = ["30Rnd_65x39_caseless_mag", 4, "Vest"];
					_items pushBack ["30Rnd_65x39_caseless_mag_Tracer", 4, "Vest"];
				};
				
				case "hlc_rifle_RK62": {
					_primary_ammo_array = ["hlc_30Rnd_762x39_b_ak", 4, "Vest"];
					_items pushBack ["hlc_30Rnd_762x39_t_ak", 4, "Vest"];
				};
			};
			
			_item_weapons pushBack "Binocular";
			_link_items pushBack "ItemGPS";
		};
		
		case "B_SOLDIER_AR_F": {
			if ("rhs_" call caran_checkMod) then {
				_primary_weapon = "rhs_weap_pkp";
				_primary_weapon_items = [];
				_primary_ammo_array = ["rhs_100Rnd_762x54mmR", 2, "Vest"];
			} else {
				if ("hlc" call caran_checkMod) then {
					_primary_weapon = "hlc_rifle_rpk";
					_primary_weapon_items = [];
					_primary_ammo_array = ["hlc_75Rnd_762x39_m_rpk", 2, "Vest"];
				} else {
					_primary_weapon = "arifle_MX_SW_Black_F";
					_primary_weapon_items = ["optic_Aco", "bipod_01_F_blk"];
					_primary_ammo_array = ["100Rnd_65x39_caseless_mag", 3, "Vest"];
				};
			};
		};
		
		case "B_SOLDIER_AAR_F": {
			_backpack = "B_AssaultPack_blk";
			
			if ("rhs_" call caran_checkMod) then {
				_items pushBack ["rhs_100Rnd_762x54mmR", 3, "Backpack"];
			} else {
				if ("hlc" call caran_checkMod) then {
					_items pushBack ["hlc_75Rnd_762x39_m_rpk", 4, "Backpack"];
				} else {
					_items pushBack ["100Rnd_65x39_caseless_mag", 6, "Backpack"];
				};
			};
		};
		
		case "B_SOLDIER_M_F": {
			if ("rhs_" call caran_checkMod) then {
				_primary_weapon = "rhs_weap_svds";
				_primary_weapon_items = ["rhs_acc_pso1m21"];
				_primary_ammo_array = ["rhs_10Rnd_762x54mmR_7N1", 10, "Vest"];
				_handgun_ammo_array set [1, 4];
			} else {
				_primary_weapon = "arifle_MXM_Black_F";
				_primary_weapon_items = ["optic_DMS", "bipod_01_F_blk"];
				_primary_ammo_array = ["30Rnd_65x39_caseless_mag", 8, "Vest"];
			};
		};
		
		//Medic gets a backpack and medical supplies (ACE if active, vanilla if not)
		case "B_MEDIC_F": {
			_backpack = "B_AssaultPack_blk";
			
			if ( "ace_" call caran_checkMod ) then {
				_items set [ count _items, ["ACE_personalAidKit", 1, "Backpack"]];
				_items set [ count _items, ["ACE_bloodIV", 2, "Backpack"]];
				_items set [ count _items, ["ACE_bloodIV_500", 4, "Backpack"]];
				_items set [ count _items, ["ACE_tourniquet", 5, "Backpack"]];
				{ _items set [count _items, [_x, 10, "Backpack"]]; } forEach ["ACE_morphine", "ACE_epinephrine", "ACE_atropine"];
				{ _items set [count _items, [_x, 25, "Backpack"]]; } forEach ["ACE_packingBandage", "ACE_elasticBandage"];
			} else {
				_items set [ count _items, ["Medikit", 1, "Backpack"]];
				_items set [ count _items, ["FirstAidKit", 10, "Backpack"]];
			};
		};
	};

	//Adding gear. 
	[player, _uniform, _vest, _backpack, _headwear] call caran_addClothing;
	[player, _items] call caran_addInventoryItems;
	[player, _link_items] call caran_addLinkedItems;
	[player, _item_weapons] call caran_addInventoryWeapons;
	[player, _primary_weapon, _primary_weapon_items, _primary_ammo_array] call caran_addPrimaryWeapon;
	[player, _handgun, _handgun_items, _handgun_ammo_array] call caran_addHandgun;

} else {

	_backpack = "";
	
	//Medical. ACE if active, vanilla if not
	if ( "ace_" call caran_checkMod ) then {
		{
			for "_i" from 1 to 4 do {
				player addItemToUniform _x;
			};
		} forEach ["ACE_morphine", "ACE_epinephrine"];
		
		{
			for "_i" from 1 to 8 do {
				player addItemToUniform _x;
			};
		} forEach  ["ACE_elasticBandage", "ACE_packingBandage"];
		
		player addItemToUniform "ACE_tourniquet";
		
		//also maptools
		player addItemToUniform "ACE_MapTools";
		
	} else {
		
		for "_i" from 1 to 2 do {
			player addItemToUniform "FirstAidKit";
		};
	};
	
	if (_class == "B_MEDIC_F") then {
		player addBackpack "B_AssaultPack_blk";
			
		if ( "ace_" call caran_checkMod ) then {
			player addItemToBackpack "ACE_personalAidKit";
			for "_i" from 1 to 2 do { player addItemToBackpack "ACE_bloodIV"; };
			for "_i" from 1 to 4 do { player addItemToBackpack "ACE_bloodIV_400"; };
			for "_i" from 1 to 5 do { player addItemToBackpack "ACE_tourniquet"; };
			{
				for "_i" from 1 to 10 do { player addItemToBackpack _x; };
			} forEach ["ACE_morphine", "ACE_epinephrine", "ACE_atropine"];
			{
				for "_i" from 1 to 25 do { player addItemToBackpack _x; };
			} forEach ["ACE_packingBandage", "ACE_elasticBandage"];
		} else {
			player addItemToBackpack "Medikit";
			for "_i" from 1 to 10 do { player addItemToBackpack "FirstAidKit"; };
		};
	};
};