class User {
  final String id;
  String name;
  String phone;
  final String email;
  int nottiPoints;
  double totalSpending;
  MemberTier tier;
  List<String> savedAddresses;
  DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.nottiPoints = 0,
    this.totalSpending = 0.0,
    required this.tier,
    this.savedAddresses = const [],
    required this.joinDate,
  });

  // Progress ke next tier
  double getProgressToNextTier() {
    switch (tier) {
      case MemberTier.mattina:
        return (totalSpending / 1000000).clamp(0.0, 1.0); // 1 juta untuk Pomeriggio
      case MemberTier.pomeriggio:
        return (totalSpending / 5000000).clamp(0.0, 1.0); // 5 juta untuk Notte
      case MemberTier.notte:
        return 1.0;
    }
  }

  String getNextTierAmount() {
    switch (tier) {
      case MemberTier.mattina:
        return 'Rp ${(1000000 - totalSpending).toStringAsFixed(0)}';
      case MemberTier.pomeriggio:
        return 'Rp ${(5000000 - totalSpending).toStringAsFixed(0)}';
      case MemberTier.notte:
        return 'Max Tier Reached';
    }
  }
}

enum MemberTier {
  mattina,
  pomeriggio, 
  notte,
}

extension MemberTierExtension on MemberTier {
  String get name {
    switch (this) {
      case MemberTier.mattina:
        return 'Mattina';
      case MemberTier.pomeriggio:
        return 'Pomeriggio';
      case MemberTier.notte:
        return 'Notte';
    }
  }

  String get emoji {
    switch (this) {
      case MemberTier.mattina:
        return '☀';
      case MemberTier.pomeriggio:
        return '🌤';
      case MemberTier.notte:
        return '🌙';
    }
  }

  String get description {
    switch (this) {
      case MemberTier.mattina:
        return 'Start your journey with us';
      case MemberTier.pomeriggio:
        return 'Enjoy exclusive benefits';
      case MemberTier.notte:
        return 'Premium membership privileges';
    }
  }
}