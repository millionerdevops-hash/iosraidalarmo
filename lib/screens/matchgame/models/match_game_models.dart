import 'package:flutter/material.dart';

enum MatchDifficulty { grub, chad, zerg }

class MatchItem {
  final String id;
  final String imageUrl;
  final String rarity; // yellow, blue, red, gray

  const MatchItem({
    required this.id,
    required this.imageUrl,
    required this.rarity,
  });
}

class MatchCard {
  final int id;
  final MatchItem item;
  bool isFlipped;
  bool isMatched;

  MatchCard({
    required this.id,
    required this.item,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class DifficultyConfig {
  final int pairs;
  final int gridCols;
  final int bet;
  final int win;
  final int time;
  final Color color;

  const DifficultyConfig({
    required this.pairs,
    required this.gridCols,
    required this.bet,
    required this.win,
    required this.time,
    required this.color,
  });
}

const Map<MatchDifficulty, DifficultyConfig> DIFFICULTIES = {
  MatchDifficulty.grub: DifficultyConfig(
    pairs: 6,
    gridCols: 3,
    bet: 25,
    win: 50,
    time: 30,
    color: Color(0xFFA1A1AA),
  ),
  MatchDifficulty.chad: DifficultyConfig(
    pairs: 10,
    gridCols: 4,
    bet: 100,
    win: 250,
    time: 45,
    color: Color(0xFFF97316),
  ),
  MatchDifficulty.zerg: DifficultyConfig(
    pairs: 12,
    gridCols: 4,
    bet: 250,
    win: 750,
    time: 60,
    color: Color(0xFFEF4444),
  ),
};

const List<MatchItem> GAME_ITEMS = [
  // === AUTOMATIC WEAPONS ===
  MatchItem(id: 'ak47', imageUrl: 'assets/images/png/ingame/weapons/automatic/assault-rifle.png', rarity: 'yellow'),
  MatchItem(id: 'custom_smg', imageUrl: 'assets/images/png/ingame/weapons/automatic/custom-smg.png', rarity: 'blue'),
  MatchItem(id: 'hmlmg', imageUrl: 'assets/images/png/ingame/weapons/automatic/hmlmg.png', rarity: 'yellow'),
  MatchItem(id: 'm249', imageUrl: 'assets/images/png/ingame/weapons/automatic/lmg-m249.png', rarity: 'yellow'),
  MatchItem(id: 'minigun', imageUrl: 'assets/images/png/ingame/weapons/automatic/minigun.png', rarity: 'red'),
  MatchItem(id: 'lr300', imageUrl: 'assets/images/png/ingame/weapons/automatic/rifle-lr300.png', rarity: 'yellow'),
  MatchItem(id: 'mp5', imageUrl: 'assets/images/png/ingame/weapons/automatic/smg-mp5.png', rarity: 'blue'),
  MatchItem(id: 'thompson', imageUrl: 'assets/images/png/ingame/weapons/automatic/smg-thompson.png', rarity: 'blue'),
  
  // === LAUNCHER WEAPONS ===
  MatchItem(id: 'mgl', imageUrl: 'assets/images/png/ingame/weapons/launcher/multiple-grenade-launcher.png', rarity: 'red'),
  MatchItem(id: 'rocket_launcher', imageUrl: 'assets/images/png/ingame/weapons/launcher/rocket-launcher.png', rarity: 'red'),
  
  // === SEMI-AUTOMATIC WEAPONS ===
  MatchItem(id: 'bolty', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/bolt-action-rifle.png', rarity: 'yellow'),
  MatchItem(id: 'high_caliber', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/high-caliber-revolver.png', rarity: 'blue'),
  MatchItem(id: 'l96', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/l96-rifle.png', rarity: 'yellow'),
  MatchItem(id: 'm39', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/m39-rifle.png', rarity: 'blue'),
  MatchItem(id: 'm92', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/m92-pistol.png', rarity: 'blue'),
  MatchItem(id: 'prototype17', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/prototype-17.png', rarity: 'blue'),
  MatchItem(id: 'python', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/python-revolver.png', rarity: 'blue'),
  MatchItem(id: 'sar', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/rifle-semiauto.png', rarity: 'blue'),
  MatchItem(id: 'sap', imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/semi-automatic-pistol.png', rarity: 'blue'),
  
  // === SHOTGUN WEAPONS ===
  MatchItem(id: 'db', imageUrl: 'assets/images/png/ingame/weapons/shotgun/double-barrel-shotgun.png', rarity: 'blue'),
  MatchItem(id: 'm4', imageUrl: 'assets/images/png/ingame/weapons/shotgun/m4-shotgun.png', rarity: 'yellow'),
  MatchItem(id: 'pump', imageUrl: 'assets/images/png/ingame/weapons/shotgun/pump-shotgun.png', rarity: 'blue'),
  MatchItem(id: 'spas12', imageUrl: 'assets/images/png/ingame/weapons/shotgun/spas-12-shotgun.png', rarity: 'yellow'),
  MatchItem(id: 'waterpipe', imageUrl: 'assets/images/png/ingame/weapons/shotgun/waterpipe-shotgun.png', rarity: 'gray'),
  
  // === MELEE & TOOLS ===
  MatchItem(id: 'jackhammer', imageUrl: 'assets/images/png/ingame/weapons/melee/jackhammer.png', rarity: 'blue'),
  MatchItem(id: 'chainsaw', imageUrl: 'assets/images/png/ingame/weapons/melee/chainsaw.png', rarity: 'blue'),
  MatchItem(id: 'combat_knife', imageUrl: 'assets/images/png/ingame/weapons/melee/combat-knife.png', rarity: 'blue'),
  MatchItem(id: 'revolver', imageUrl: 'assets/images/png/ingame/weapons/melee/pistol-revolver.png', rarity: 'gray'),
  MatchItem(id: 'baseball_bat', imageUrl: 'assets/images/png/ingame/weapons/melee/baseball-bat.png', rarity: 'gray'),
  MatchItem(id: 'bone_club', imageUrl: 'assets/images/png/ingame/weapons/melee/bone-club.png', rarity: 'gray'),
  MatchItem(id: 'bone_knife', imageUrl: 'assets/images/png/ingame/weapons/melee/bone-knife.png', rarity: 'gray'),
  MatchItem(id: 'compound_bow', imageUrl: 'assets/images/png/ingame/weapons/melee/compound-bow.png', rarity: 'blue'),
  MatchItem(id: 'crossbow', imageUrl: 'assets/images/png/ingame/weapons/melee/crossbow.png', rarity: 'blue'),
  MatchItem(id: 'eoka_pistol', imageUrl: 'assets/images/png/ingame/weapons/melee/eoka-pistol.png', rarity: 'gray'),
  MatchItem(id: 'hatchet', imageUrl: 'assets/images/png/ingame/weapons/melee/hatchet.png', rarity: 'gray'),
  MatchItem(id: 'hunting_bow', imageUrl: 'assets/images/png/ingame/weapons/melee/hunting-bow.png', rarity: 'gray'),
  MatchItem(id: 'krieg_chainsword', imageUrl: 'assets/images/png/ingame/weapons/melee/krieg-chainsword.png', rarity: 'yellow'),
  MatchItem(id: 'longsword', imageUrl: 'assets/images/png/ingame/weapons/melee/longsword.png', rarity: 'blue'),
  MatchItem(id: 'lunar_spear', imageUrl: 'assets/images/png/ingame/weapons/melee/lunar-new-year-spear.png', rarity: 'yellow'),
  MatchItem(id: 'mace', imageUrl: 'assets/images/png/ingame/weapons/melee/mace.png', rarity: 'blue'),
  MatchItem(id: 'machete', imageUrl: 'assets/images/png/ingame/weapons/melee/machete.png', rarity: 'blue'),
  MatchItem(id: 'paddle', imageUrl: 'assets/images/png/ingame/weapons/melee/paddle.png', rarity: 'gray'),
  MatchItem(id: 'pickaxe', imageUrl: 'assets/images/png/ingame/weapons/melee/pickaxe.png', rarity: 'gray'),
  MatchItem(id: 'nailgun', imageUrl: 'assets/images/png/ingame/weapons/melee/pistol-nailgun.png', rarity: 'blue'),
  MatchItem(id: 'rock', imageUrl: 'assets/images/png/ingame/weapons/melee/rock.png', rarity: 'gray'),
  MatchItem(id: 'salvaged_axe', imageUrl: 'assets/images/png/ingame/weapons/melee/salvaged-axe.png', rarity: 'blue'),
  MatchItem(id: 'salvaged_cleaver', imageUrl: 'assets/images/png/ingame/weapons/melee/salvaged-cleaver.png', rarity: 'blue'),
  MatchItem(id: 'salvaged_hammer', imageUrl: 'assets/images/png/ingame/weapons/melee/salvaged-hammer.png', rarity: 'blue'),
  MatchItem(id: 'salvaged_icepick', imageUrl: 'assets/images/png/ingame/weapons/melee/salvaged-icepick.png', rarity: 'blue'),
  MatchItem(id: 'salvaged_sword', imageUrl: 'assets/images/png/ingame/weapons/melee/salvaged-sword.png', rarity: 'blue'),
  MatchItem(id: 'shovel', imageUrl: 'assets/images/png/ingame/weapons/melee/shovel.png', rarity: 'gray'),
  MatchItem(id: 'skinning_knife', imageUrl: 'assets/images/png/ingame/weapons/melee/skinning-knife.png', rarity: 'gray'),
  MatchItem(id: 'stone_hatchet', imageUrl: 'assets/images/png/ingame/weapons/melee/stone-hatchet.png', rarity: 'gray'),
  MatchItem(id: 'stone_pickaxe', imageUrl: 'assets/images/png/ingame/weapons/melee/stone-pickaxe.png', rarity: 'gray'),
  MatchItem(id: 'stone_spear', imageUrl: 'assets/images/png/ingame/weapons/melee/stone-spear.png', rarity: 'gray'),
  MatchItem(id: 'wooden_spear', imageUrl: 'assets/images/png/ingame/weapons/melee/wooden-spear.png', rarity: 'gray'),
  
  // === ARMOR & MEDICAL ===
  MatchItem(id: 'facemask', imageUrl: 'assets/images/png/ingame/weapons/others/metal-facemask.png', rarity: 'blue'),
  MatchItem(id: 'hazmat', imageUrl: 'assets/images/png/ingame/weapons/others/hazmat-suit.png', rarity: 'blue'),
  MatchItem(id: 'syringue', imageUrl: 'assets/images/png/ingame/weapons/others/medical-syringe.png', rarity: 'blue'),
  MatchItem(id: 'medkit', imageUrl: 'assets/images/png/ingame/weapons/others/large-medkit.png', rarity: 'blue'),
  MatchItem(id: 'coffeecan', imageUrl: 'assets/images/png/ingame/weapons/others/coffee-can-helmet.png', rarity: 'blue'),
  MatchItem(id: 'roadsign_jacket', imageUrl: 'assets/images/png/ingame/weapons/others/road-sign-jacket.png', rarity: 'blue'),
  MatchItem(id: 'bandage', imageUrl: 'assets/images/png/ingame/weapons/others/bandage.png', rarity: 'gray'),
  MatchItem(id: 'bucket_helmet', imageUrl: 'assets/images/png/ingame/weapons/others/bucket-helmet.png', rarity: 'gray'),
  MatchItem(id: 'heavy_plate_helmet', imageUrl: 'assets/images/png/ingame/weapons/others/heavy-plate-helmet.png', rarity: 'yellow'),
  MatchItem(id: 'riot_helmet', imageUrl: 'assets/images/png/ingame/weapons/others/riot-helmet.png', rarity: 'blue'),
  MatchItem(id: 'roadsign_gloves', imageUrl: 'assets/images/png/ingame/weapons/others/roadsign-gloves.png', rarity: 'blue'),
  MatchItem(id: 'tactical_gloves', imageUrl: 'assets/images/png/ingame/weapons/others/tactical-gloves.png', rarity: 'blue'),
  
  // === DAMAGE ITEMS (AMMO & EXPLOSIVES) ===
  MatchItem(id: 'buckshot', imageUrl: 'assets/images/png/ingame/damage-items/12-gauge-buckshot.png', rarity: 'gray'),
  MatchItem(id: 'incendiary_shell', imageUrl: 'assets/images/png/ingame/damage-items/12-gauge-incendiary-shell.png', rarity: 'blue'),
  MatchItem(id: 'slug', imageUrl: 'assets/images/png/ingame/damage-items/12-gauge-slug.png', rarity: 'blue'),
  MatchItem(id: '40mm_he', imageUrl: 'assets/images/png/ingame/damage-items/40mm-he-grenade.png', rarity: 'yellow'),
  MatchItem(id: '40mm_shotgun', imageUrl: 'assets/images/png/ingame/damage-items/40mm-shotgun-round.png', rarity: 'yellow'),
  MatchItem(id: 'beancan', imageUrl: 'assets/images/png/ingame/damage-items/beancan-grenade.png', rarity: 'blue'),
  MatchItem(id: 'bone_arrow', imageUrl: 'assets/images/png/ingame/damage-items/bone-arrow.png', rarity: 'gray'),
  MatchItem(id: 'explosive_ammo', imageUrl: 'assets/images/png/ingame/damage-items/explosive-rifle-ammo.png', rarity: 'yellow'),
  MatchItem(id: 'fire_arrow', imageUrl: 'assets/images/png/ingame/damage-items/fire-arrow.png', rarity: 'blue'),
  MatchItem(id: 'f1_grenade', imageUrl: 'assets/images/png/ingame/damage-items/grenade-f1.png', rarity: 'blue'),
  MatchItem(id: 'handmade_shell', imageUrl: 'assets/images/png/ingame/damage-items/handmade-shell.png', rarity: 'gray'),
  MatchItem(id: 'hv_arrow', imageUrl: 'assets/images/png/ingame/damage-items/high-velocity-arrow.png', rarity: 'blue'),
  MatchItem(id: 'hv_rocket', imageUrl: 'assets/images/png/ingame/damage-items/high-velocity-rocket.png', rarity: 'yellow'),
  MatchItem(id: 'hv_rifle_ammo', imageUrl: 'assets/images/png/ingame/damage-items/hv--rifle-ammo.png', rarity: 'blue'),
  MatchItem(id: 'hv_pistol_ammo', imageUrl: 'assets/images/png/ingame/damage-items/hv-pistol-ammo.png', rarity: 'blue'),
  MatchItem(id: 'incendiary_pistol', imageUrl: 'assets/images/png/ingame/damage-items/incendiary-pistol-ammo.png', rarity: 'blue'),
  MatchItem(id: 'incendiary_rifle', imageUrl: 'assets/images/png/ingame/damage-items/incendiary-rifle-ammo.png', rarity: 'blue'),
  MatchItem(id: 'incendiary_rocket', imageUrl: 'assets/images/png/ingame/damage-items/incendiary-rocket.png', rarity: 'yellow'),
  MatchItem(id: 'molotov', imageUrl: 'assets/images/png/ingame/damage-items/molotov.png', rarity: 'blue'),
  MatchItem(id: 'pistol_ammo', imageUrl: 'assets/images/png/ingame/damage-items/pistol-ammo.png', rarity: 'gray'),
  MatchItem(id: 'propane_bomb', imageUrl: 'assets/images/png/ingame/damage-items/propane-bomb.png', rarity: 'yellow'),
  MatchItem(id: 'rifle_ammo', imageUrl: 'assets/images/png/ingame/damage-items/rifle-ammo.png', rarity: 'gray'),
  MatchItem(id: 'rocket', imageUrl: 'assets/images/png/ingame/damage-items/rocket.png', rarity: 'yellow'),
  MatchItem(id: 'satchel', imageUrl: 'assets/images/png/ingame/damage-items/satchel-charge.png', rarity: 'yellow'),
  MatchItem(id: 'c4', imageUrl: 'assets/images/png/ingame/damage-items/timed-explosive-charge.png', rarity: 'red'),
  MatchItem(id: 'wooden_arrow', imageUrl: 'assets/images/png/ingame/damage-items/wooden-arrow.png', rarity: 'gray'),
  
  // === DIESEL CALCULATOR (RESOURCES) ===
  MatchItem(id: 'crude_oil', imageUrl: 'assets/images/png/ingame/diesel-calculator/crude-oil.png', rarity: 'blue'),
  MatchItem(id: 'diesel_barrel', imageUrl: 'assets/images/png/ingame/diesel-calculator/diesel-barrel.png', rarity: 'blue'),
  MatchItem(id: 'hqm_ore', imageUrl: 'assets/images/png/ingame/diesel-calculator/hq-metal-ore.png', rarity: 'yellow'),
  MatchItem(id: 'lowgrade', imageUrl: 'assets/images/png/ingame/diesel-calculator/lowgradefuel.png', rarity: 'blue'),
  MatchItem(id: 'metal_frags', imageUrl: 'assets/images/png/ingame/diesel-calculator/metal-fragments.png', rarity: 'gray'),
  MatchItem(id: 'metal_ore', imageUrl: 'assets/images/png/ingame/diesel-calculator/metal-ore.png', rarity: 'gray'),
  MatchItem(id: 'stones', imageUrl: 'assets/images/png/ingame/diesel-calculator/stones.png', rarity: 'gray'),
  MatchItem(id: 'sulfur_ore', imageUrl: 'assets/images/png/ingame/diesel-calculator/sulfur-ore.png', rarity: 'blue'),
];
