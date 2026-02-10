class RecoilPoint {
  final double x;
  final double y;

  const RecoilPoint({required this.x, required this.y});

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}

enum RecoilDifficulty { easy, medium, hard, extreme }

class RecoilPattern {
  final String id;
  final String name;
  final int rpm;
  final int ammoCapacity;
  final String description;
  final RecoilDifficulty difficulty;
  final String imageUrl;
  final List<RecoilPoint> pattern;

  const RecoilPattern({
    required this.id,
    required this.name,
    required this.rpm,
    required this.ammoCapacity,
    required this.description,
    required this.difficulty,
    required this.imageUrl,
    required this.pattern,
  });
}

// --- PATTERNS ---

const List<RecoilPoint> ak47Pattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 2, y: 12), RecoilPoint(x: 3, y: 25), RecoilPoint(x: 4, y: 38), RecoilPoint(x: 5, y: 50), RecoilPoint(x: 5, y: 60),
  RecoilPoint(x: 8, y: 68), RecoilPoint(x: 12, y: 75), RecoilPoint(x: 18, y: 80), RecoilPoint(x: 24, y: 83), RecoilPoint(x: 28, y: 85),
  RecoilPoint(x: 25, y: 87), RecoilPoint(x: 18, y: 88), RecoilPoint(x: 8, y: 89), RecoilPoint(x: -5, y: 90), RecoilPoint(x: -18, y: 91),
  RecoilPoint(x: -28, y: 92), RecoilPoint(x: -35, y: 93), RecoilPoint(x: -38, y: 93), RecoilPoint(x: -35, y: 94), RecoilPoint(x: -28, y: 94),
  RecoilPoint(x: -18, y: 95), RecoilPoint(x: -5, y: 95), RecoilPoint(x: 8, y: 96), RecoilPoint(x: 20, y: 96), RecoilPoint(x: 28, y: 96),
  RecoilPoint(x: 32, y: 97), RecoilPoint(x: 28, y: 97), RecoilPoint(x: 20, y: 98), RecoilPoint(x: 10, y: 98), RecoilPoint(x: 0, y: 98)
];

const List<RecoilPoint> lr300Pattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 0, y: 9), RecoilPoint(x: -1, y: 18), RecoilPoint(x: -1, y: 27), RecoilPoint(x: 0, y: 36), RecoilPoint(x: 1, y: 45),
  RecoilPoint(x: 2, y: 53), RecoilPoint(x: 3, y: 60), RecoilPoint(x: 3, y: 66), RecoilPoint(x: 2, y: 71), RecoilPoint(x: 0, y: 76),
  RecoilPoint(x: -2, y: 80), RecoilPoint(x: -4, y: 84), RecoilPoint(x: -5, y: 87), RecoilPoint(x: -5, y: 90), RecoilPoint(x: -4, y: 93),
  RecoilPoint(x: -2, y: 95), RecoilPoint(x: 0, y: 97), RecoilPoint(x: 2, y: 98), RecoilPoint(x: 4, y: 99), RecoilPoint(x: 5, y: 100),
  RecoilPoint(x: 5, y: 101), RecoilPoint(x: 4, y: 102), RecoilPoint(x: 2, y: 103), RecoilPoint(x: 0, y: 104), RecoilPoint(x: -2, y: 104),
  RecoilPoint(x: -3, y: 105), RecoilPoint(x: -3, y: 105), RecoilPoint(x: -2, y: 106), RecoilPoint(x: 0, y: 106)
];

const List<RecoilPoint> mp5Pattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 1, y: 8), RecoilPoint(x: 2, y: 16), RecoilPoint(x: 4, y: 24), RecoilPoint(x: 5, y: 32), RecoilPoint(x: 6, y: 40),
  RecoilPoint(x: 8, y: 48), RecoilPoint(x: 9, y: 55), RecoilPoint(x: 10, y: 62), RecoilPoint(x: 10, y: 68), RecoilPoint(x: 9, y: 74),
  RecoilPoint(x: 7, y: 79), RecoilPoint(x: 5, y: 83), RecoilPoint(x: 3, y: 86), RecoilPoint(x: 2, y: 88), RecoilPoint(x: 2, y: 90),
  RecoilPoint(x: 3, y: 92), RecoilPoint(x: 5, y: 93), RecoilPoint(x: 7, y: 94), RecoilPoint(x: 9, y: 95), RecoilPoint(x: 10, y: 96),
  RecoilPoint(x: 10, y: 97), RecoilPoint(x: 9, y: 98), RecoilPoint(x: 7, y: 98), RecoilPoint(x: 5, y: 99), RecoilPoint(x: 4, y: 99),
  RecoilPoint(x: 4, y: 100), RecoilPoint(x: 5, y: 100), RecoilPoint(x: 6, y: 101), RecoilPoint(x: 7, y: 101)
];

const List<RecoilPoint> thompsonPattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 1, y: 8), RecoilPoint(x: 3, y: 16), RecoilPoint(x: 5, y: 24), RecoilPoint(x: 7, y: 32), RecoilPoint(x: 9, y: 40),
  RecoilPoint(x: 11, y: 48), RecoilPoint(x: 12, y: 56), RecoilPoint(x: 13, y: 64), RecoilPoint(x: 14, y: 72), RecoilPoint(x: 14, y: 80),
  RecoilPoint(x: 14, y: 88), RecoilPoint(x: 13, y: 94), RecoilPoint(x: 11, y: 100), RecoilPoint(x: 9, y: 105), RecoilPoint(x: 7, y: 110),
  RecoilPoint(x: 6, y: 114), RecoilPoint(x: 5, y: 118), RecoilPoint(x: 5, y: 122), RecoilPoint(x: 6, y: 126)
];

const List<RecoilPoint> customSmgPattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: -1, y: 7), RecoilPoint(x: -2, y: 14), RecoilPoint(x: -3, y: 21), RecoilPoint(x: -4, y: 28), RecoilPoint(x: -4, y: 35),
  RecoilPoint(x: -3, y: 42), RecoilPoint(x: -1, y: 48), RecoilPoint(x: 2, y: 54), RecoilPoint(x: 5, y: 59), RecoilPoint(x: 7, y: 63),
  RecoilPoint(x: 8, y: 67), RecoilPoint(x: 7, y: 70), RecoilPoint(x: 5, y: 73), RecoilPoint(x: 2, y: 75), RecoilPoint(x: -1, y: 77),
  RecoilPoint(x: -3, y: 79), RecoilPoint(x: -4, y: 81), RecoilPoint(x: -3, y: 83), RecoilPoint(x: 0, y: 85), RecoilPoint(x: 3, y: 87),
  RecoilPoint(x: 5, y: 89), RecoilPoint(x: 6, y: 90), RecoilPoint(x: 5, y: 91)
];

const List<RecoilPoint> hmlmgPattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 0, y: 10), RecoilPoint(x: 1, y: 20), RecoilPoint(x: 2, y: 30), RecoilPoint(x: 3, y: 40), RecoilPoint(x: 4, y: 50),
  RecoilPoint(x: 5, y: 60), RecoilPoint(x: 5, y: 68), RecoilPoint(x: 4, y: 76), RecoilPoint(x: 2, y: 83), RecoilPoint(x: 0, y: 90),
  RecoilPoint(x: -2, y: 95), RecoilPoint(x: -4, y: 100), RecoilPoint(x: -5, y: 105), RecoilPoint(x: -5, y: 110), RecoilPoint(x: -4, y: 115),
  RecoilPoint(x: -2, y: 120), RecoilPoint(x: 0, y: 124), RecoilPoint(x: 2, y: 128), RecoilPoint(x: 4, y: 132), RecoilPoint(x: 5, y: 135),
  RecoilPoint(x: 5, y: 138), RecoilPoint(x: 4, y: 140), RecoilPoint(x: 2, y: 142), RecoilPoint(x: 0, y: 143), RecoilPoint(x: -2, y: 144),
  RecoilPoint(x: -4, y: 145), RecoilPoint(x: -5, y: 146), RecoilPoint(x: -5, y: 147), RecoilPoint(x: -4, y: 148)
];

const List<RecoilPoint> sarPattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 0, y: 15), RecoilPoint(x: 0, y: 30), RecoilPoint(x: 0, y: 45), RecoilPoint(x: 0, y: 60),
  RecoilPoint(x: 0, y: 75), RecoilPoint(x: 0, y: 90), RecoilPoint(x: 0, y: 105), RecoilPoint(x: 0, y: 120),
  RecoilPoint(x: 0, y: 135), RecoilPoint(x: 0, y: 150), RecoilPoint(x: 0, y: 165), RecoilPoint(x: 0, y: 180),
  RecoilPoint(x: 0, y: 195), RecoilPoint(x: 0, y: 210), RecoilPoint(x: 0, y: 225)
];

const List<RecoilPoint> pythonPattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 0, y: 25), RecoilPoint(x: 0, y: 50), RecoilPoint(x: 0, y: 75), RecoilPoint(x: 0, y: 100),
  RecoilPoint(x: 0, y: 125), RecoilPoint(x: 0, y: 150)
];

const List<RecoilPoint> m39Pattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 0, y: 10), RecoilPoint(x: 0, y: 20), RecoilPoint(x: 0, y: 30), RecoilPoint(x: 0, y: 40),
  RecoilPoint(x: 0, y: 50), RecoilPoint(x: 0, y: 60), RecoilPoint(x: 0, y: 70), RecoilPoint(x: 0, y: 80),
  RecoilPoint(x: 0, y: 90), RecoilPoint(x: 0, y: 100), RecoilPoint(x: 0, y: 110), RecoilPoint(x: 0, y: 120),
  RecoilPoint(x: 0, y: 130), RecoilPoint(x: 0, y: 140), RecoilPoint(x: 0, y: 150), RecoilPoint(x: 0, y: 160),
  RecoilPoint(x: 0, y: 170), RecoilPoint(x: 0, y: 180), RecoilPoint(x: 0, y: 190)
];

const List<RecoilPoint> m249Pattern = [
  RecoilPoint(x: 0, y: 0),
  RecoilPoint(x: 0, y: 15), RecoilPoint(x: 1, y: 30), RecoilPoint(x: 1, y: 45), RecoilPoint(x: 0, y: 60), RecoilPoint(x: -1, y: 75),
  RecoilPoint(x: -2, y: 90), RecoilPoint(x: -2, y: 100), RecoilPoint(x: -1, y: 110), RecoilPoint(x: 1, y: 118), RecoilPoint(x: 3, y: 125),
  RecoilPoint(x: 5, y: 130), RecoilPoint(x: 6, y: 135), RecoilPoint(x: 5, y: 140), RecoilPoint(x: 3, y: 145), RecoilPoint(x: 0, y: 150),
  RecoilPoint(x: -3, y: 155), RecoilPoint(x: -5, y: 160), RecoilPoint(x: -6, y: 163), RecoilPoint(x: -5, y: 165), RecoilPoint(x: -3, y: 167),
  RecoilPoint(x: 0, y: 168), RecoilPoint(x: 3, y: 169), RecoilPoint(x: 5, y: 170), RecoilPoint(x: 6, y: 171), RecoilPoint(x: 5, y: 172),
  RecoilPoint(x: 3, y: 173), RecoilPoint(x: 0, y: 174), RecoilPoint(x: -3, y: 175), RecoilPoint(x: -5, y: 176)
];

// --- WEAPONS ---

const List<RecoilPattern> weapons = [
  RecoilPattern(
    id: 'ak47',
    name: 'AK-47',
    rpm: 450,
    ammoCapacity: 30,
    description: 'Hardest pattern. Pull down hard, then trace the S shape.',
    difficulty: RecoilDifficulty.hard,
    imageUrl: 'assets/images/png/ingame/weapons/automatic/assault-rifle.png',
    pattern: ak47Pattern,
  ),
  RecoilPattern(
    id: 'lr300',
    name: 'LR-300',
    rpm: 500,
    ammoCapacity: 30,
    description: 'Consistent vertical rise. Pull straight down.',
    difficulty: RecoilDifficulty.easy,
    imageUrl: 'assets/images/png/ingame/weapons/automatic/rifle-lr300.png',
    pattern: lr300Pattern,
  ),
  RecoilPattern(
    id: 'mp5',
    name: 'MP5A4',
    rpm: 600,
    ammoCapacity: 30,
    description: 'Fast fire rate. Initial kick is the hardest part.',
    difficulty: RecoilDifficulty.medium,
    imageUrl: 'assets/images/png/ingame/weapons/automatic/smg-mp5.png',
    pattern: mp5Pattern,
  ),
  RecoilPattern(
    id: 'thompson',
    name: 'Thompson',
    rpm: 460,
    ammoCapacity: 20,
    description: 'Drifts up and to the right consistently.',
    difficulty: RecoilDifficulty.medium,
    imageUrl: 'assets/images/png/ingame/weapons/automatic/smg-thompson.png',
    pattern: thompsonPattern,
  ),
  RecoilPattern(
    id: 'custom_smg',
    name: 'SMG',
    rpm: 600,
    ammoCapacity: 24,
    description: 'Fast but shaky. Pulls left early, then erratic.',
    difficulty: RecoilDifficulty.medium,
    imageUrl: 'assets/images/png/ingame/weapons/automatic/custom-smg.png',
    pattern: customSmgPattern,
  ),
  RecoilPattern(
    id: 'hmlmg',
    name: 'HMLMG',
    rpm: 500,
    ammoCapacity: 60,
    description: 'Craftable LMG. Like AK but heavier pull.',
    difficulty: RecoilDifficulty.hard,
    imageUrl: 'assets/images/png/ingame/weapons/automatic/hmlmg.png',
    pattern: hmlmgPattern,
  ),
  RecoilPattern(
    id: 'sar',
    name: 'Semi Rifle',
    rpm: 400,
    ammoCapacity: 16,
    description: 'Pure vertical recoil. Pull down after every tap.',
    difficulty: RecoilDifficulty.easy,
    imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/rifle-semiauto.png',
    pattern: sarPattern,
  ),
  RecoilPattern(
    id: 'm39',
    name: 'M39',
    rpm: 300,
    ammoCapacity: 20,
    description: 'High accuracy, moderate vertical kick.',
    difficulty: RecoilDifficulty.medium,
    imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/m39-rifle.png',
    pattern: m39Pattern,
  ),
  RecoilPattern(
    id: 'python',
    name: 'Revolver',
    rpm: 300,
    ammoCapacity: 6,
    description: 'Massive kick. Requires heavy pull down.',
    difficulty: RecoilDifficulty.hard,
    imageUrl: 'assets/images/png/ingame/weapons/semi-automatic/python-revolver.png',
    pattern: pythonPattern,
  ),
  RecoilPattern(
    id: 'm249',
    name: 'M249',
    rpm: 500,
    ammoCapacity: 100,
    description: 'Extreme vertical recoil. Crouch to control.',
    difficulty: RecoilDifficulty.extreme,
    imageUrl: 'assets/images/png/ingame/weapons/automatic/lmg-m249.png',
    pattern: m249Pattern,
  ),
];
