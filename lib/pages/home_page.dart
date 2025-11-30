import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/point_provider.dart';
import '../providers/tier_provider.dart';
import '../constants/colors.dart';
import 'rewards_page.dart';
import 'profile_page.dart';
import 'merch_page.dart';
import 'promos_page.dart';
import 'deals_page.dart';
import 'add_points_page.dart';
import 'tier_page.dart';
import 'inbox_page.dart';
import 'promo_detail_page.dart';
import 'history_page.dart';
import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    _HomeContent(),
    RewardsPage(),
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
          NavigationDestination(
            icon: Icon(Icons.card_giftcard),
            label: "Rewards",
          ),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  int unreadCount = 0;

  static final List<Map<String, dynamic>> promos = [
    {
      "title": "50% Cashback with GoPay",
      "merchant": "GoPay",
      "period": "Valid until 30 Nov",
      "description":
          "Get 50% cashback up to Rp 20,000 for payments using GoPay or GoPay Later. Valid 1x/user/week.",
      "colors": [const Color(0xFF00AA13), const Color(0xFF00C318)],
      "image": "assets/gopay.png",
      "terms": ["Min. transaction Rp 40,000", "Valid for Dine-in only"],
      "steps": [
        "Open Gojek app and select 'Pay'.",
        "Scan the QRIS available at the cashier.",
        "Ensure the payment amount is correct.",
        "Click 'Apply Promo' and select the cashback voucher.",
        "Complete the payment.",
      ],
    },
    {
      "title": "Rp 15k Off with OVO",
      "merchant": "OVO",
      "period": "1-15 Dec 2024",
      "description":
          "Direct discount of Rp 15,000 with a minimum transaction of Rp 100,000 using OVO Cash/Points.",
      "colors": [const Color(0xFF4C3494), const Color(0xFF6946C6)],
      "image": "assets/ovo.png",
      "terms": [
        "Min. transaction Rp 100,000",
        "Multiple transactions not allowed",
      ],
      "steps": [
        "Inform the cashier you want to pay with OVO.",
        "Open OVO app and scan the QR Code.",
        "Enter transaction amount (min. Rp 100,000).",
        "Discount will be automatically applied.",
        "Confirm payment.",
      ],
    },
    {
      "title": "Pay 1 Get 2 with Mandiri",
      "merchant": "Bank Mandiri",
      "period": "Weekend Only",
      "description":
          "Buy any 1 Main Course menu, get 1 selected Pasta menu for free with Mandiri Credit Card.",
      "colors": [const Color(0xFF003D79), const Color(0xFF005CAA)],
      "image": "assets/mandiri.png",
      "terms": ["Saturday & Sunday only", "Signature & World Cards"],
      "steps": [
        "Order 1 Main Course and 1 Pasta of your choice.",
        "Use Mandiri Credit Card for payment.",
        "The cashier will deduct the price of the lower-priced item.",
        "Keep the receipt as proof of transaction.",
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    final notifJson = prefs.getStringList('notifications') ?? [];

    if (notifJson.isEmpty) {
      setState(() => unreadCount = 2);
    } else {
      final notifications = notifJson
          .map((n) => jsonDecode(n) as Map<String, dynamic>)
          .toList();
      final count = notifications.where((n) => n['read'] == false).length;
      setState(() => unreadCount = count);
    }
  }

  Future<void> _navigateToInbox() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InboxPage()),
    );
    _loadUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Consumer2<PointProvider, TierProvider>(
      builder: (context, pointProvider, tierProvider, child) {
        final points = pointProvider.points;
        final pointsAccumulated = pointProvider.pointsAccumulated;
        final currentTier = tierProvider.getCurrentTier(pointsAccumulated);
        final nextTier = tierProvider.getNextTier(pointsAccumulated);
        final progress = tierProvider.getProgressToNextTier(pointsAccumulated);
        final pointsToNext = tierProvider.getPointsToNextTier(
          pointsAccumulated,
        );
        return Scaffold(
          backgroundColor: AppColors.cream,
          appBar: AppBar(
            title: const Text(
              'Notte Azzura Point',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            centerTitle: true,
            elevation: 0,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: _navigateToInbox,
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.orange,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 9 ? '9+' : '$unreadCount',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.red, AppColors.red.withOpacity(0.8)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                    child: Column(
                      children: [
                        LoyaltyCard(
                          userName: userProvider.fullName,
                          currentTier: currentTier,
                        ),
                        const SizedBox(height: 20),
                        PointsSection(
                          currentPoints: points,
                          pointsAccumulated: pointsAccumulated,
                          currentTier: currentTier,
                          nextTier: nextTier,
                          progress: progress,
                          pointsToNext: pointsToNext,
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DealsPage(),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/HomeBanner.jpg',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      AppColors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.orange,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        '🔥 HOT DEALS',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Exclusive Offers\nJust For You',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          const Text(
                            "Quick Access",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '4',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.redDark,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _featureCard(
                            context,
                            icon: Icons.add_circle,
                            title: "Add\nPoints",
                            gradient: LinearGradient(
                              colors: [AppColors.orange, AppColors.redLight],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddPointsPage(),
                                ),
                              );
                            },
                          ),
                          _featureCard(
                            context,
                            icon: Icons.history,
                            title: "Transaction\nHistory",
                            gradient: LinearGradient(
                              colors: [AppColors.green, AppColors.greenDark],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HistoryPage(),
                                ),
                              );
                            },
                          ),
                          _featureCard(
                            context,
                            icon: Icons.store,
                            title: "Our\nMerchandise",
                            gradient: LinearGradient(
                              colors: [
                                AppColors.info,
                                AppColors.info.withOpacity(0.7),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MerchPage(),
                                ),
                              );
                            },
                          ),
                          _featureCard(
                            context,
                            icon: Icons.star,
                            title: "Hot\nDeals",
                            gradient: LinearGradient(
                              colors: [AppColors.gold, AppColors.warning],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DealsPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Special Promo",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PromosPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "See All",
                              style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ...promos.map((promo) => _promoCard(context, promo)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _featureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.white, size: 28),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _promoCard(BuildContext context, Map<String, dynamic> promo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PromoDetailPage(promo: promo),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: promo['colors'],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (promo['colors'][0] as Color).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Positioned(
              left: -15,
              bottom: -25,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(0.08),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            promo['merchant'].toString().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          promo['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_filled,
                              color: Colors.white70,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              promo['period'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoyaltyCard extends StatelessWidget {
  final String userName;
  final TierInfo currentTier;

  const LoyaltyCard({
    super.key,
    this.userName = 'Morris',
    required this.currentTier,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TierPage()),
        );
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: currentTier.accentColor.withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: currentTier.gradient,
                borderRadius: BorderRadius.circular(24),
              ),
            ),

            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CustomPaint(painter: CardPatternPainter()),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              currentTier.icon,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notte Azzura',
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(0.9),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Loyalty Member',
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(0.7),
                                  fontSize: 9,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              color: AppColors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              currentTier.name.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Member since 2024',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PointsSection extends StatelessWidget {
  final int currentPoints;
  final int pointsAccumulated;
  final TierInfo currentTier;
  final TierInfo? nextTier;
  final double progress;
  final int pointsToNext;

  const PointsSection({
    super.key,
    required this.currentPoints,
    required this.pointsAccumulated,
    required this.currentTier,
    required this.nextTier,
    required this.progress,
    required this.pointsToNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Points Balance',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currentPoints.toStringAsFixed(0),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'pts',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              if (nextTier != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Next Tier',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nextTier!.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: AppColors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'MAX',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (nextTier != null) ...[
            const SizedBox(height: 12),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}% to next tier',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$pointsToNext pts left',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(size.width + 40, -40 + (i * 80)),
        60 + (i * 20),
        paint,
      );
    }

    for (int i = 0; i < 2; i++) {
      canvas.drawCircle(
        Offset(-40, size.height - 40 + (i * 40)),
        40 + (i * 20),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
