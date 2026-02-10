
class TeaRecipeInput {
  final String name;
  final int count;
  final String img;

  const TeaRecipeInput({
    required this.name,
    required this.count,
    required this.img,
  });
}

class TeaRecipe {
  final List<TeaRecipeInput> inputs;

  const TeaRecipe({required this.inputs});
}

class TeaStat {
  final String label;
  final String value;
  final bool isPositive;

  const TeaStat({
    required this.label,
    required this.value,
    required this.isPositive,
  });
}

class TeaDef {
  final String id;
  final String name;
  final String type;
  final String tier;
  final String duration;
  final String description;
  final List<TeaStat> stats;
  final TeaRecipe recipe;
  final String color;
  final String image;

  const TeaDef({
    required this.id,
    required this.name,
    required this.type,
    required this.tier,
    required this.duration,
    required this.description,
    required this.stats,
    required this.recipe,
    required this.color,
    required this.image,
  });
}

class BerryImages {
  static const String yellow = 'assets/images/png/ingame/tea/berry/yellow-berry.png';
  static const String white = 'assets/images/png/ingame/tea/berry/white-berry.png';
  static const String red = 'assets/images/png/ingame/tea/berry/red-berry.png';
  static const String green = 'assets/images/png/ingame/tea/berry/green-berry.png';
  static const String blue = 'assets/images/png/ingame/tea/berry/blue-berry.png';
}

class TeaImages {
  // Basic
  static const String radBasic = 'assets/images/png/ingame/tea/basic-tea/anti-rad.png';
  static const String healingBasic = 'assets/images/png/ingame/tea/basic-tea/healing.png';
  static const String hpBasic = 'assets/images/png/ingame/tea/basic-tea/maxhealth.png';
  static const String coolingBasic = 'assets/images/png/ingame/tea/basic-tea/cooling.png';
  static const String warmingBasic = 'assets/images/png/ingame/tea/basic-tea/warming.png';
  static const String craftingBasic = 'assets/images/png/ingame/tea/basic-tea/crafting-quality.png';
  static const String oreBasic = 'assets/images/png/ingame/tea/basic-tea/ore.png';
  static const String harvestBasic = 'assets/images/png/ingame/tea/basic-tea/harvesting.png';
  static const String woodBasic = 'assets/images/png/ingame/tea/basic-tea/wood.png';
  static const String scrapBasic = 'assets/images/png/ingame/tea/basic-tea/scrap.png';

  // Advanced
  static const String radAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-anti-rad.png';
  static const String healingAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-healing.png';
  static const String hpAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-maxhealth.png';
  static const String coolingAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-cooling.png';
  static const String warmingAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-warming.png';
  static const String craftingAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-crafting-quality.png';
  static const String oreAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-ore.png';
  static const String scrapAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-scrap.png';
  static const String harvestAdv = 'assets/images/png/ingame/tea/advanced-tea/advance-harvesting.png';
  static const String woodAdv = 'assets/images/png/ingame/tea/advanced-tea/advanced-wood.png';

  // Pure
  static const String radPure = 'assets/images/png/ingame/tea/pure-tea/pure-anti-rad.png';
  static const String healingPure = 'assets/images/png/ingame/tea/pure-tea/pure-healing.png';
  static const String hpPure = 'assets/images/png/ingame/tea/pure-tea/pure-maxhealth.png';
  static const String coolingPure = 'assets/images/png/ingame/tea/pure-tea/pure-cooling.png';
  static const String warmingPure = 'assets/images/png/ingame/tea/pure-tea/pure-warming.png';
  static const String craftingPure = 'assets/images/png/ingame/tea/pure-tea/pure-crafting-quality.png';
  static const String orePure = 'assets/images/png/ingame/tea/pure-tea/oretea-pure.png';
  static const String scrapPure = 'assets/images/png/ingame/tea/pure-tea/pure-scrap.png';
  static const String harvestPure = 'assets/images/png/ingame/tea/pure-tea/pure-harvesting.png';
  static const String woodPure = 'assets/images/png/ingame/tea/pure-tea/pure-wood.png';
}

List<TeaDef> createTeaFamily(
  String type,
  String colorClass, // Keeping the name as colorClass but content is still the tailwind string, will be parsed or used as ID
  Map<String, String> imgKeys,
  Map<String, dynamic> basicData,
  Map<String, dynamic> advData,
  Map<String, dynamic> pureData,
) {
  // Basic Definition
  final basicTea = TeaDef(
    id: '${type}_basic',
    name: 'tea_guide_details.teas.${type}_basic.name',
    type: type,
    tier: 'Basic', // Keep raw value for logic
    duration: basicData['duration'],
    description: 'tea_guide_details.teas.${type}_basic.desc',
    stats: basicData['stats'],
    recipe: TeaRecipe(inputs: basicData['inputs']),
    color: colorClass,
    image: imgKeys['basic']!,
  );

  // Advanced Definition
  final advTea = TeaDef(
    id: '${type}_adv',
    name: 'tea_guide_details.teas.${type}_adv.name',
    type: type,
    tier: 'Advanced', // Keep raw value for logic
    duration: advData['duration'],
    description: 'tea_guide_details.teas.${type}_adv.desc',
    stats: advData['stats'],
    recipe: TeaRecipe(
      inputs: [
        TeaRecipeInput(
          name: 'tea_guide_details.teas.${type}_basic.name', // Basic input for advanced
          count: 4,
          img: imgKeys['basic']!,
        ),
      ],
    ),
    color: colorClass,
    image: imgKeys['adv']!,
  );

  // Pure Definition
  final pureTea = TeaDef(
    id: '${type}_pure',
    name: 'tea_guide_details.teas.${type}_pure.name',
    type: type,
    tier: 'Pure', // Keep raw value for logic
    duration: pureData['duration'],
    description: 'tea_guide_details.teas.${type}_pure.desc',
    stats: pureData['stats'],
    recipe: TeaRecipe(
      inputs: [
        TeaRecipeInput(
          name: 'tea_guide_details.teas.${type}_adv.name', // Adv input for pure
          count: 4,
          img: imgKeys['adv']!,
        ),
      ],
    ),
    color: colorClass,
    image: imgKeys['pure']!,
  );

  return [basicTea, advTea, pureTea];
}

final List<TeaDef> teaDatabase = [
  // 1. ANTI-RAD TEA
  ...createTeaFamily(
    'Rad',
    'text-orange-500 bg-orange-900/10 border-orange-500/50',
    {
      'basic': TeaImages.radBasic,
      'adv': TeaImages.radAdv,
      'pure': TeaImages.radPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Red_Berry', count: 2, img: BerryImages.red),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Green_Berry', count: 2, img: BerryImages.green),
      ],
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.rad_res', value: '+15%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.rad_res', value: '+30%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.rad_res', value: '+45%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 2. COOLING TEA
  ...createTeaFamily(
    'Cooling',
    'text-cyan-400 bg-cyan-900/10 border-cyan-500/50',
    {
      'basic': TeaImages.coolingBasic,
      'adv': TeaImages.coolingAdv,
      'pure': TeaImages.coolingPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.White_Berry', count: 2, img: BerryImages.white),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Blue_Berry', count: 2, img: BerryImages.blue),
      ],
      'duration': 'tea_guide_details.durations.20m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.temp', value: '+10°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.max_temp', value: '+40°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.45m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.temp', value: '+15°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.max_temp', value: '+40°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.1h',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.temp', value: '+20°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.max_temp', value: '+40°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 3. CRAFTING QUALITY TEA
  ...createTeaFamily(
    'Crafting',
    'text-purple-400 bg-purple-900/10 border-purple-500/50',
    {
      'basic': TeaImages.craftingBasic,
      'adv': TeaImages.craftingAdv,
      'pure': TeaImages.craftingPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Green_Berry', count: 3, img: BerryImages.green),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.White_Berry', count: 1, img: BerryImages.white),
      ],
      'duration': 'tea_guide_details.durations.3m_20s',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.quality', value: '+50%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.5m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.quality', value: '+75%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.6m_40s',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.quality', value: '+85%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 4. HARVESTING TEA
  ...createTeaFamily(
    'Harvesting',
    'text-lime-400 bg-lime-900/10 border-lime-500/50',
    {
      'basic': TeaImages.harvestBasic,
      'adv': TeaImages.harvestAdv,
      'pure': TeaImages.harvestPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Yellow_Berry', count: 1, img: BerryImages.yellow),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Green_Berry', count: 3, img: BerryImages.green),
      ],
      'duration': 'tea_guide_details.durations.20m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+35%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.20m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+50%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.20m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+65%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 5. HEALING TEA
  ...createTeaFamily(
    'Healing',
    'text-red-500 bg-red-900/10 border-red-500/50',
    {
      'basic': TeaImages.healingBasic,
      'adv': TeaImages.healingAdv,
      'pure': TeaImages.healingPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Red_Berry', count: 4, img: BerryImages.red),
      ],
      'duration': 'tea_guide_details.durations.instant',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.hot', value: '+30 HP', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.instant',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.hot', value: '+50 HP', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.inst_hp', value: '+5 HP', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.instant',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.hot', value: '+75 HP', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.inst_hp', value: '+10 HP', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 6. MAX HEALTH TEA
  ...createTeaFamily(
    'MaxHealth',
    'text-emerald-500 bg-emerald-900/10 border-emerald-500/50',
    {
      'basic': TeaImages.hpBasic,
      'adv': TeaImages.hpAdv,
      'pure': TeaImages.hpPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Red_Berry', count: 3, img: BerryImages.red),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Yellow_Berry', count: 1, img: BerryImages.yellow),
      ],
      'duration': 'tea_guide_details.durations.20m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.max_hp', value: '+5%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.20m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.max_hp', value: '+12.5%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.20m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.max_hp', value: '+20%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 7. ORE TEA
  ...createTeaFamily(
    'Ore',
    'text-yellow-500 bg-yellow-900/10 border-yellow-500/50',
    {
      'basic': TeaImages.oreBasic,
      'adv': TeaImages.oreAdv,
      'pure': TeaImages.orePure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Yellow_Berry', count: 2, img: BerryImages.yellow),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Blue_Berry', count: 2, img: BerryImages.blue),
      ],
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+20%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+35%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+50%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 8. SCRAP TEA
  ...createTeaFamily(
    'Scrap',
    'text-zinc-300 bg-zinc-900/10 border-zinc-500/50',
    {
      'basic': TeaImages.scrapBasic,
      'adv': TeaImages.scrapAdv,
      'pure': TeaImages.scrapPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Yellow_Berry', count: 2, img: BerryImages.yellow),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.White_Berry', count: 2, img: BerryImages.white),
      ],
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+100%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.45m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+225%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.1h',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+350%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 9. WARMING TEA
  ...createTeaFamily(
    'Warming',
    'text-orange-300 bg-orange-900/10 border-orange-300/50',
    {
      'basic': TeaImages.warmingBasic,
      'adv': TeaImages.warmingAdv,
      'pure': TeaImages.warmingPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.White_Berry', count: 2, img: BerryImages.white),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Yellow_Berry', count: 2, img: BerryImages.yellow),
      ],
      'duration': 'tea_guide_details.durations.20m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.temp', value: '+5°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.min_temp', value: '-15°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.45m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.temp', value: '+10°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.min_temp', value: '-8°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.1h',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.temp', value: '+15°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.min_temp', value: '0°', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),

  // 10. WOOD TEA
  ...createTeaFamily(
    'Wood',
    'text-amber-600 bg-amber-900/10 border-amber-600/50',
    {
      'basic': TeaImages.woodBasic,
      'adv': TeaImages.woodAdv,
      'pure': TeaImages.woodPure
    },
    {
      'inputs': [
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Red_Berry', count: 2, img: BerryImages.red),
        const TeaRecipeInput(name: 'tea_guide_details.ingredients.Blue_Berry', count: 2, img: BerryImages.blue),
      ],
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+50%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+100%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
    {
      'duration': 'tea_guide_details.durations.30m',
      'stats': [
        const TeaStat(label: 'tea_guide_details.stats.yield', value: '+200%', isPositive: true),
        const TeaStat(label: 'tea_guide_details.stats.hydration', value: '+30', isPositive: true),
      ]
    },
  ),
];
