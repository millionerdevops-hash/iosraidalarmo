enum Suit {
  hearts,
  diamonds,
  clubs,
  spades;

  String get acronym {
    switch (this) {
      case Suit.hearts: return 'H';
      case Suit.diamonds: return 'D';
      case Suit.clubs: return 'C';
      case Suit.spades: return 'S';
    }
  }

  bool get isRed => this == Suit.hearts || this == Suit.diamonds;
}

enum Rank {
  two('2', 2),
  three('3', 3),
  four('4', 4),
  five('5', 5),
  six('6', 6),
  seven('7', 7),
  eight('8', 8),
  nine('9', 9),
  ten('10', 10),
  jack('J', 10),
  queen('Q', 10),
  king('K', 10),
  ace('A', 11);

  final String label;
  final int value;
  const Rank(this.label, this.value);
}

class CardModel {
  final Suit suit;
  final Rank rank;
  final String id;
  bool isHidden;

  CardModel({
    required this.suit,
    required this.rank,
    required this.id,
    this.isHidden = false,
  });

  int get value => rank.value;
}

enum BlackjackGamePhase {
  betting,
  dealing,
  playerTurn,
  dealerTurn,
  resolving,
  gameOver;
}
