import 'package:flutter/material.dart';
import 'pages/rewards_page.dart';
import 'pages/profile_page.dart';
import 'pages/add_points_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';

void main() {
  runApp(const LoyaltyApp());
}

class LoyaltyApp extends StatelessWidget {
  const LoyaltyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notte Azzura Point',
      home: const ProfilePage(), ///NANTI GANTI LAGI KE HOMEPAGE
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade800),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF800000);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notte Azzura Point'),
        backgroundColor: maroon,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hi, Morris",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Your Points Now: 1,250 pts",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _menuButton(
                  context,
                  Icons.card_giftcard,
                  "Exchange",
                  maroon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RewardsPage(userPoints: 1250),
                      ),
                    );
                  },
                ),
                _menuButton(context, Icons.history, "History", maroon),
                _menuButton(context, Icons.store, "Merchant", maroon),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Special Promo For You",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  _promoItem("Promo 1"),
                  _promoItem("Promo 2"),
                  _promoItem("Promo 3"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _menuButton(
  BuildContext context,
  IconData icon,
  String label,
  Color color, {
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    ),
  );
}

class _promoItem extends StatelessWidget {
  final String title;
  const _promoItem(this.title);

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF800000);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.local_offer, color: maroon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: maroon),
      ),
    );
  }
}
