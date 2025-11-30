import 'package:flutter/material.dart';

enum TierLevel {
  mattina,
  pomeriggio,
  notte,
}

class TierInfo {
  final TierLevel level;
  final String name;
  final String subtitle;
  final int minPoints;
  final int maxPoints;
  final Gradient gradient;
  final IconData icon;
  final List<String> benefits;
  final Color accentColor;
  final double discount;

  TierInfo({
    required this.level,
    required this.name,
    required this.subtitle,
    required this.minPoints,
    required this.maxPoints,
    required this.gradient,
    required this.icon,
    required this.benefits,
    required this.accentColor,
    required this.discount,
  });

  String get pointsRange => maxPoints == -1
      ? '$minPoints+ points'
      : '$minPoints - $maxPoints points';
}

class TierProvider extends ChangeNotifier {
  static const Color green = Color(0xFF4CAF50);
  static const Color greenLight = Color(0xFF81C784);
  static const Color gold = Color(0xFFFFD700);
  static const Color warning = Color(0xFFFFA726);
  static const Color orange = Color(0xFFFF9800);

  final List<TierInfo> _tiers = [
    TierInfo(
      level: TierLevel.mattina,
      name: 'Mattina',
      subtitle: 'Basic Membership',
      minPoints: 0,
      maxPoints: 1999,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [greenLight, green],
      ),
      icon: Icons.wb_twilight,
      benefits: [
        '5% discount on all menu',
        'Birthday reward',
        'Access to member promos',
        'Collect points on purchases',
      ],
      accentColor: green,
      discount: 0.05,
    ),
    TierInfo(
      level: TierLevel.pomeriggio,
      name: 'Pomeriggio',
      subtitle: 'Premium Membership',
      minPoints: 2000,
      maxPoints: 7999,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [gold, warning],
      ),
      icon: Icons.wb_sunny,
      benefits: [
        '15% discount on all menu',
        'Free delivery over 100k',
        'Priority order processing',
        'Monthly special promo',
        'Bonus 3x points multiplier',
      ],
      accentColor: orange,
      discount: 0.15,
    ),
    TierInfo(
      level: TierLevel.notte,
      name: 'Notte',
      subtitle: 'Elite Membership',
      minPoints: 8000,
      maxPoints: -1,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
      ),
      icon: Icons.nightlight,
      benefits: [
        '30% discount on all menu',
        'Free delivery for all orders',
        'Priority reservation',
        'Exclusive menu access',
        'Birthday special gift',
        'Bonus 5x points multiplier',
        'VIP customer service',
      ],
      accentColor: gold,
      discount: 0.30,
    ),
  ];

  List<TierInfo> get allTiers => _tiers;

  TierInfo getCurrentTier(int points) {
    for (var tier in _tiers.reversed) {
      if (points >= tier.minPoints) {
        return tier;
      }
    }
    return _tiers.first;
  }

  TierInfo? getNextTier(int points) {
    final currentTier = getCurrentTier(points);
    final currentIndex = _tiers.indexOf(currentTier);
    
    if (currentIndex < _tiers.length - 1) {
      return _tiers[currentIndex + 1];
    }
    return null;
  }

  int getPointsToNextTier(int points) {
    final nextTier = getNextTier(points);
    if (nextTier == null) return 0;
    return nextTier.minPoints - points;
  }

  double getProgressToNextTier(int points) {
    final currentTier = getCurrentTier(points);
    final nextTier = getNextTier(points);
    
    if (nextTier == null) return 1.0;
    
    final currentMin = currentTier.minPoints;
    final nextMin = nextTier.minPoints;
    final progress = (points - currentMin) / (nextMin - currentMin);
    
    return progress.clamp(0.0, 1.0);
  }

  int getCurrentTierIndex(int points) {
    final currentTier = getCurrentTier(points);
    return _tiers.indexOf(currentTier);
  }
}