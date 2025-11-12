import 'package:flutter/material.dart';
import '../models/reward.dart';

class RewardsPage extends StatefulWidget {
  final int userPoints;
  const RewardsPage({Key? key, required this.userPoints}) : super(key: key);

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  late int points;

  // daftar reward dummy
  final List<Reward> rewards = [
    Reward(id: 'r1', name: 'Side Dish', pointsNeeded: 50, tier: 'bronze'),
    Reward(id: 'r2', name: 'Pasta', pointsNeeded: 120, tier: 'silver'),
    Reward(id: 'r3', name: 'Pizza', pointsNeeded: 200, tier: 'gold'),
  ];

  @override
  void initState() {
    super.initState();
    points = widget.userPoints;
  }

  // warna berdasarkan tier
  Color tierColor(String tier) {
    switch (tier) {
      case 'gold':
        return Colors.amber.shade700;
      case 'silver':
        return Colors.grey;
      default:
        return Colors.brown.shade300;
    }
  }

  void onRedeem(Reward reward) async {
    if (points < reward.pointsNeeded) return;

    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Redeem'),
        content: Text('Tukar ${reward.name} dengan ${reward.pointsNeeded} Notti Points?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Redeem'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        points -= reward.pointsNeeded;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil menukar ${reward.name}!')),
      );
      // nanti di sini diarahkan ke halaman QR
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎁 Rewards')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: rewards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final r = rewards[index];
            final locked = points < r.pointsNeeded;

            return Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: tierColor(r.tier).withOpacity(0.15),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.card_giftcard, size: 50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          r.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('${r.pointsNeeded} Notti Points'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: locked ? null : () => onRedeem(r),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Redeem'),
                        ),
                      ],
                    ),
                  ),
                ),
                if (locked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.lock, size: 36, color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
