#include "..\logic\gear.sqf"

//Get _this class and make sure it's all uppercase since BI classnames are super inconsistent
_class = typeOf _this;
_class = toUpper _class;

//Define default gear types. Leave as is if no change from default unit required (or remove both from here and from calls at the end of this file)
_uniform = "";
_vest = "";
_backpack = "";
_headwear = ["",""];

_items = [];
_link_items = [];
_item_weapons = [];

_primary_weapon = "";
_primary_weapon_items = [];
_primary_ammo_array = [];

_secondary_weapon = "";
_secondary_weapon_items = [];
_secondary_ammo_array = [];

_handgun = "";
_handgun_items = [];
_handgun_ammo_array = [];

_guer_uniforms = [
	"U_BG_Guerrilla_6_1",
	"U_BG_Guerilla1_1",
	"U_BG_Guerilla2_1",
	"U_BG_Guerilla2_3",
	"U_BG_leader",
	"U_I_G_resistanceLeader_F"
];

_guer_vests = [
	"V_BandollierB_blk",
	"V_BandollierB_cbr",
	"V_BandollierB_rgr",
	"V_BandollierB_khk",
	"V_BandollierB_oli",
	"V_TacVest_blk",
	"V_TacVest_brn",
	"V_TacVest_khk",
	"V_TacVest_oli"
];

_guer_headwears = [
	[["H_Shemag_olive", "H_ShemagOpen_tan", "H_ShemagOpen_khk"],[""]],
	[[""],["G_Balaclava_blk", "G_Balaclava_oli" ]],
	[
		["H_Booniehat_tan", "H_Booniehat_oli", "H_Bandanna_sand", "H_Bandanna_gry", "H_Bandanna_blu", "H_Bandanna_cbr", "H_Bandanna_khk", "H_Bandanna_sgg"],
		["G_Sport_Blackred", "G_Sport_Checkered", "G_Sport_BlackWhite", "G_Sport_Blackyellow", "G_Sport_Red", "G_Shades_Red", "G_Shades_Green", "G_Shades_Blue", "G_Shades_Black", "G_Bandanna_blk", "G_Bandanna_khk", "G_Bandanna_oli", "G_Bandanna_tan"]
	]
];

if (side _this == resistance) then {
	
	_this call caran_clearInventory;
	
	_uniform = _guer_uniforms select floor random count _guer_uniforms;
	_vest = _guer_vests select floor random count _guer_vests;
	
	_headwears = _guer_headwears select floor random count _guer_headwears;
	_headwear = [(_headwears select 0) select floor random count (_headwears select 0), (_headwears select 1) select floor random count (_headwears select 1) ];
	if (random 1 < 0.8) then { _headwear set [0, ""]; };
	if (random 1 < 0.8) then { _headwear set [1, ""]; };
	
	_items = [ ["FirstAidKit", 2, "Vest"] ];
	_link_items = ["ItemMap", "ItemCompass", "ItemWatch"];
	
	_primary_weapon = "arifle_TRG21_F";
	_primary_ammo_array = ["30Rnd_556x45_Stanag", 10, "Vest"];
	
	if ("rhs_" call caran_checkMod) then {
		_primary_weapon = "rhs_weap_akm";
		_primary_ammo_array = ["rhs_30Rnd_762x39mm", 8, "Vest"];
	};
	
	if ("hlcweapons_aks" call caran_checkMod) then {
		_primary_weapon = "hlc_rifle_akm";
		_primary_ammo_array = ["hlc_30Rnd_762x39_b_ak", 6, "Vest"];
	};
	
	if (_class == "I_G_OFFICER_F") then {
		_uniform = "U_I_OfficerUniform";
		_vest = "V_PlateCarrierIAGL_dgtl";
		_headwears = ["H_Beret_blk","G_Aviator"];
		_item_weapons = ["Binocular"];
	};
	
	//Adding gear. 
	[_this, _uniform, _vest, _backpack, _headwear] call caran_addClothing;
	[_this, _items] call caran_addInventoryItems;
	[_this, _link_items] call caran_addLinkedItems;
	[_this, _item_weapons] call caran_addInventoryWeapons;
	[_this, _primary_weapon, _primary_weapon_items, _primary_ammo_array] call caran_addPrimaryWeapon;
};

