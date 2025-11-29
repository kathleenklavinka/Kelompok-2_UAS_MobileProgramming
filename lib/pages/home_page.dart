import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'rewards_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    _HomeContent(),
    RewardsPage(userPoints: 10),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,

      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        indicatorColor: AppColors.gold.withOpacity(0.25),
        onDestinationSelected: (i) => setState(() => selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.card_giftcard), label: "Rewards"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,


      appBar: AppBar(
        title: const Text('Notte Azzura Point'),
        backgroundColor: AppColors.red,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/HomeBanner.jpg',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),
              _profileCard(),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _menuBox(Icons.card_giftcard, "Add Points", AppColors.redLight),
                  _menuBox(Icons.history, "History", AppColors.green),
                  _menuBox(Icons.store, "Merchant", AppColors.orange),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Special Promo For You",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              _promoCard("Midnight Pizza Deal", "Buy 1 Get 1", true),
              _promoCard("Birthday Reward", "Free Slice", false),
              _promoCard("Voucher Spesial", "Diskon 25%", true),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _profileCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.gold,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, Morris",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Points: 1,250 pts",
              style: TextStyle(color: AppColors.grayDark),
            ),
          ],
        ),
        Icon(Icons.stars, color: AppColors.red, size: 40),
      ],
    ),
  );
}

Widget _menuBox(IconData icon, String label, Color bgColor) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Icon(icon, color: AppColors.white, size: 26),
      ),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(color: AppColors.black)),
    ],
  );
}

Widget _promoCard(String title, String subtitle, bool highlight) {
  final Color badgeColor = highlight ? AppColors.greenDark : AppColors.orange;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.08),
          blurRadius: 6,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: ListTile(
      leading: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.local_offer, color: AppColors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.grayDark),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grayDark),
    ),
  );
}