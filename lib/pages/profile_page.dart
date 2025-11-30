// ignore_for_file: deprecated_member_use, prefer_final_fields, unused_element_parameter

import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';
import 'package:azzura_rewards/services/profile_service.dart';
import 'package:azzura_rewards/pages/edit_profile_page.dart';
import 'package:azzura_rewards/pages/saved_address_page.dart';
import 'package:azzura_rewards/pages/faq_page.dart';
import 'package:azzura_rewards/pages/brand_story_page.dart';
import 'package:azzura_rewards/pages/newsroom_page.dart';
import 'package:azzura_rewards/pages/contact_us_page.dart';
import 'package:azzura_rewards/pages/terms_of_use.dart';
import 'package:azzura_rewards/pages/privacy_policy_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/point_provider.dart';
import '../providers/transaction_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  Map<String, String> profileData = {};
  Uint8List? avatarBytes;

  int streakDays = 0;
  DateTime? lastCheckIn;

  List<String> badges = [];

  late AnimationController _controller;
  late AnimationController _streakController;
  late AnimationController _avatarController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _streakPulse;
  late Animation<double> _avatarScale;

  Map<String, AnimationController> _badgeControllers = {};
  List<Map<String, dynamic>> _activities = 
  [
    {
      "id": "first_purchase",
      "title": "Make your first purchase",
      "points": 5,
      "badge": "first_purchase",
      "completed": false,
    },
    {
      "id": "referral_1",
      "title": "Refer a friend",
      "points": 3,
      "badge": "referral_1",
      "completed": false,
    },
    {
      "id": "visit_5",
      "title": "Visit 5 times",
      "points": 4,
      "badge": "visit_5",
      "completed": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadStreak();
    _loadBadges();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _streakController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _streakPulse = Tween<double>(begin: 1.0, end: 1.15)
        .animate(CurvedAnimation(parent: _streakController, curve: Curves.easeInOut));

    _avatarController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _avatarScale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut));

    _controller.forward();
  }

  IconData _iconForBadge(String key) {
    switch (key) {
      case 'first_purchase':
        return Icons.star;
      case 'referral_1':
        return Icons.person_add;
      case 'visit_5':
        return Icons.location_on;
      default:
        return Icons.emoji_events;
    }
  }

  String _nameForBadge(String key) {
    switch (key) {
      case 'first_purchase':
        return 'First Purchase';
      case 'referral_1':
        return 'Referral Master';
      case 'visit_5':
        return '5 Day Streak';
      default:
        return 'Special Badge';
    }
  }

  Color _colorForBadge(String key) {
    switch (key) {
      case 'first_purchase':
        return AppColors.gold;
      case 'referral_1':
        return AppColors.greenDark;
      case 'visit_5':
        return AppColors.red;
      default:
        return AppColors.white;
    }
  }

  String greeting() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return "Good Morning";
    if (h >= 12 && h < 17) return "Good Afternoon";
    if (h >= 17 && h < 21) return "Good Evening";
    return "Good Night";
  }

  String greetingEmoji() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return "🌞";
    if (h >= 12 && h < 17) return "🌤️";
    if (h >= 17 && h < 21) return "🌥️";
    return "🌝";
  }

  Future<void> _loadData() async {
    final data = await ProfileService.loadProfile();
    setState(() {
      profileData = data;
      if (data["avatar"] != null && data["avatar"]!.isNotEmpty) {
        avatarBytes = base64Decode(data["avatar"]!);
      }
    });
  }

  Future<void> _loadStreak() async {
    final streak = await ProfileService.loadStreak();
    setState(() {
      streakDays = streak["days"] ?? 0;
      final last = streak["lastCheckIn"];
      if (last != null) lastCheckIn = DateTime.tryParse(last);
    });
  }

  Future<void> _loadBadges() async {
    badges = await loadBadges();
    setState(() {});
  }

  Future<void> _pickAvatar() async {
    _avatarController.forward().then((_) => _avatarController.reverse());
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.first.bytes != null) {
      final bytes = result.files.first.bytes!;
      await ProfileService.saveAvatar(base64Encode(bytes));
      setState(() => avatarBytes = bytes);
    }
  }

  String formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return "-";
    final match = RegExp(r'^\+\d{1,2}').firstMatch(phone);
    if (match == null) return phone;
    final prefix = match.group(0)!;
    final number = phone.substring(prefix.length);
    return "$prefix $number";
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static Future<void> saveBadges(List<String> badges) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("badges", badges);
  }

  static Future<List<String>> loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("badges") ?? [];
  }

  void _unlockBadge(String badgeKey) async {
    if (badges.contains(badgeKey)) return;
    badges.add(badgeKey);
    await saveBadges(badges);
    setState(() {});
    _showBadgeUnlockedDialog(badgeKey);
  }

  void _showBadgeUnlockedDialog(String badge) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => ScaleTransition(
        scale: CurvedAnimation(
          parent: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 400),
          )..forward(),
          curve: Curves.elasticOut,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: AppColors.cream,
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _colorForBadge(badge),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconForBadge(badge),
                  size: 48,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "🎉 Badge Unlocked!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: AppColors.redDark,
                ),
              ),
            ],
          ),
          content: Text(
            _nameForBadge(badge),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.greenDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Awesome!", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeInfo(String key) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.cream,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: badges.contains(key) ? _colorForBadge(key) : AppColors.grayLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconForBadge(key),
                color: badges.contains(key) ? AppColors.white : AppColors.grayDark,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _nameForBadge(key),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.redDark,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          badges.contains(key) 
            ? "You've earned this badge! Keep up the great work!"
            : "Complete the required actions to unlock this badge.",
          style: TextStyle(color: AppColors.greenDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {String? trailing, VoidCallback? onTap}) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grayLight.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.redDark.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.greenLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 22, color: AppColors.greenDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.redDark,
                        ),
                      ),
                    ),
                    if (trailing != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.greenLight.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          trailing,
                          style: const TextStyle(
                            color: AppColors.greenDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.grayDark.withOpacity(0.5)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.redDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.greenLight.withOpacity(0.1),
            AppColors.redLight.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final badgeKey in ['first_purchase','referral_1','visit_5'])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => _showBadgeInfo(badgeKey),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: badges.contains(badgeKey)
                              ? LinearGradient(
                                  colors: [
                                    _colorForBadge(badgeKey),
                                    _colorForBadge(badgeKey).withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: badges.contains(badgeKey)
                              ? null
                              : AppColors.grayLight.withOpacity(0.5),
                          shape: BoxShape.circle,
                          boxShadow: badges.contains(badgeKey)
                              ? [
                                  BoxShadow(
                                    color: _colorForBadge(badgeKey).withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          _iconForBadge(badgeKey),
                          size: 28,
                          color: badges.contains(badgeKey)
                              ? AppColors.white
                              : AppColors.grayDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _nameForBadge(badgeKey),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: badges.contains(badgeKey)
                              ? AppColors.greenDark
                              : AppColors.grayDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _completeActivity(Map<String, dynamic> activity) async {
    if (activity["completed"] == true) return;

    setState(() {
      activity["completed"] = true;
    });

    _unlockBadge(activity["badge"]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Quest completed! You earned ${activity["points"]} points and unlocked '${activity["badge"]}' badge.",
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    context.read<PointProvider>().addPoints(activity["points"]);

    context.read<TransactionProvider>().addTransaction(
      type: 'earn',
      name: activity["title"],
      description: activity["title"],
      points: activity["points"],
      category: "Activities",
      image: "🎯",
      tier: '',
      status: 'completed',
    );
    
    await saveBadges(badges);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.redDark,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.redDark, AppColors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [AppColors.redLight, AppColors.redDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.redDark.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _avatarScale,
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.green,
                              backgroundImage:
                                  avatarBytes != null ? MemoryImage(avatarBytes!) : null,
                              child: avatarBytes == null
                                  ? const Icon(Icons.person,
                                      size: 40, color: AppColors.cream)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileData["name"] ?? "--",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                formatPhone(profileData["phone"]),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit_rounded, color: AppColors.white),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditProfilePage()),
                            );
                            if (result == true) _loadData();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.greenLight.withOpacity(0.15),
                        AppColors.cream,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.greenLight.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        greetingEmoji(),
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${greeting()}, ${profileData['name'] ?? '--'}!",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.redDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Keep your streak alive today 🔥",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.greenDark.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.gold.withOpacity(0.1),
                        AppColors.red.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.gold.withOpacity(0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _streakPulse,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.gold, AppColors.gold.withOpacity(0.7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_fire_department,
                            color: AppColors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Streak",
                              style: TextStyle(
                                color: AppColors.grayDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "$streakDays Days",
                              style: const TextStyle(
                                color: AppColors.redDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () async {
                          final now = DateTime.now();
                          if (lastCheckIn == null ||
                              !isSameDate(lastCheckIn!, now)) {
                            if (lastCheckIn != null &&
                                isSameDate(
                                    lastCheckIn!.add(const Duration(days: 1)),
                                    now)) {
                              streakDays++;
                            } else {
                              streakDays = 1;
                            }
                            lastCheckIn = now;
                            await ProfileService.saveStreak(
                                streakDays, lastCheckIn!.toIso8601String());
                            setState(() {});
                            if (streakDays == 5) _unlockBadge("visit_5");
                          }
                        },
                        child: const Text(
                          "Check-in",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Your Achievements"),
                if (badges.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.grayLight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_events_outlined, 
                            color: AppColors.grayDark, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Start earning badges by completing activities!",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grayDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  _buildBadgesRow(),
              ],
            ),

            const SizedBox(height: 32),

            if (_activities.isNotEmpty) ...[
              const SizedBox(height: 30),
              _buildSectionTitle("Activities"),

              Column(
                children: _activities.map((activity) {
                  final completed = activity["completed"] == true;

                  return GestureDetector(
                    onTap: () => _completeActivity(activity),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.grayLight.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: completed
                                  ? AppColors.greenDark.withOpacity(0.2)
                                  : AppColors.grayLight.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              completed ? Icons.check_circle : Icons.flag_outlined,
                              color: completed ? AppColors.greenDark : AppColors.grayDark,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: completed
                                        ? AppColors.greenDark
                                        : AppColors.grayDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "+${activity["points"]} points • Badge: ${activity["badge"]}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.grayDark,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            completed ? Icons.done : Icons.arrow_forward_ios,
                            size: 14,
                            color:
                                completed ? AppColors.greenDark : AppColors.grayDark,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 32),

            _buildSectionTitle("General"),
            _buildMenuItem(
              Icons.home_outlined,
              "Saved Address",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedAddressPage()),
              ),
            ),
            _buildMenuItem(
              Icons.help_outline,
              "FAQ",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQPage()),
              ),
            ),
            _buildMenuItem(Icons.chat_bubble_outline, "Live Chat"),
            _buildMenuItem(
              Icons.help_outline,
              "Contact Us",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsPage()),
              ),
            ),
            _buildMenuItem(Icons.star_border, "Rate Our App", trailing: "v4.0.41"),

            const SizedBox(height: 32),

            _buildSectionTitle("About Us"),
            _buildMenuItem(
              Icons.local_pizza,
              "Brand Story",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BrandStoryPage()),
              ),
            ),
            _buildMenuItem(Icons.verified, "Halal Certificate"),
            _buildMenuItem(
              Icons.newspaper,
              "Newsroom",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsroomPage()),
              ),
            ),
            _buildMenuItem(Icons.pin_drop, "Outlet Location"),

            const SizedBox(height: 32),

            _buildSectionTitle("Privacy & Security"),
            _buildMenuItem(
              Icons.help_outline,
              "Terms Of Use",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsOfUsePage()),
              ),
            ),
            _buildMenuItem(
              Icons.help_outline,
              "Privacy Policy",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _streakController.dispose();
    _avatarController.dispose();

    for (var c in _badgeControllers.values) {
      c.dispose();
    }

    super.dispose();
  }
}