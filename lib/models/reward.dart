class Reward {
  final String id;
  final String name;
  final String? imageUrl;
  final int pointsNeeded;
  final String tier;

  Reward({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.pointsNeeded,
    required this.tier,
  });
}