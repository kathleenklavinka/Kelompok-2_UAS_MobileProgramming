import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';
import 'inbox_page.dart';

// MULTISTATE ENUM
enum RewardPageState { loading, loaded, error, redeeming }

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  RewardPageState _currentState = RewardPageState.loading;

  // User data - akan dimuat dari SharedPreferences
  int userNottiPoints = 2450;
  String userTier = "Ruby";
  int userLevel = 15;

  // Rewards data
  final List<Map<String, dynamic>> rewards = [
    {
      'id': 'reward_1',
      'name': 'Side Dish Special',
      'description': 'French Fries atau Salad',
      'points': 500,
      'category': 'Side Dish',
      'image': '🍟',
      'tier': 'Bronze',
      'redeemed': false,
    },
    {
      'id': 'reward_2',
      'name': 'Garlic Bread',
      'description': 'With butter & herbs',
      'points': 800,
      'category': 'Side Dish',
      'image': '🥖',
      'tier': 'Bronze',
      'redeemed': false,
    },
    {
      'id': 'reward_3',
      'name': 'Pasta Aglio Olio',
      'description': 'Classic Italian pasta',
      'points': 1500,
      'category': 'Pasta',
      'image': '🍝',
      'tier': 'Silver',
      'redeemed': false,
    },
    {
      'id': 'reward_4',
      'name': 'Carbonara Pasta',
      'description': 'Creamy & delicious',
      'points': 1800,
      'category': 'Pasta',
      'image': '🍝',
      'tier': 'Silver',
      'redeemed': false,
    },
    {
      'id': 'reward_5',
      'name': 'Margherita Pizza',
      'description': 'Classic tomato & cheese',
      'points': 2500,
      'category': 'Pizza',
      'image': '🍕',
      'tier': 'Gold',
      'redeemed': false,
    },
    {
      'id': 'reward_6',
      'name': 'Pepperoni Pizza',
      'description': 'With extra cheese',
      'points': 3000,
      'category': 'Pizza',
      'image': '🍕',
      'tier': 'Gold',
      'redeemed': false,
    },
    {
      'id': 'reward_7',
      'name': 'Premium Steak',
      'description': 'Wagyu beef premium',
      'points': 5000,
      'category': 'Main Course',
      'image': '🥩',
      'tier': 'Diamond',
      'redeemed': false,
    },
    {
      'id': 'reward_8',
      'name': 'Lobster Dinner',
      'description': 'Fresh lobster special',
      'points': 8000,
      'category': 'Main Course',
      'image': '🦞',
      'tier': 'Diamond',
      'redeemed': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadRewards();
  }

  // LOAD DATA DARI SHAREDPREFERENCES
  Future<void> _loadRewards() async {
    setState(() => _currentState = RewardPageState.loading);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load user points & level
      userNottiPoints = prefs.getInt('userNottiPoints') ?? 2450;
      userLevel = prefs.getInt('userLevel') ?? 15;
      userTier = prefs.getString('userTier') ?? 'Ruby';

      // Load redeemed rewards
      final redeemedIds = prefs.getStringList('redeemedRewards') ?? [];
      for (var reward in rewards) {
        reward['redeemed'] = redeemedIds.contains(reward['id']);
      }

      await Future.delayed(Duration(seconds: 1));

      setState(() => _currentState = RewardPageState.loaded);
      _animationController.forward();
    } catch (e) {
      setState(() => _currentState = RewardPageState.error);
    }
  }

  // SAVE USER DATA KE SHAREDPREFERENCES
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userNottiPoints', userNottiPoints);
    await prefs.setInt('userLevel', userLevel);
    await prefs.setString('userTier', userTier);
  }

  // SAVE REDEEMED REWARDS KE SHAREDPREFERENCES
  Future<void> _saveRedeemedRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final redeemedIds = rewards
        .where((r) => r['redeemed'] == true)
        .map((r) => r['id'] as String)
        .toList();
    await prefs.setStringList('redeemedRewards', redeemedIds);
  }

  // RESET DATA (untuk testing)
  Future<void> _resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loadRewards();
  }

  Future<void> _saveTransaction(Map<String, dynamic> reward) async {
    final prefs = await SharedPreferences.getInstance();
    
    final transaction = {
      'id': 'trans_${DateTime.now().millisecondsSinceEpoch}',
      'type': 'redeemed',
      'points': reward['points'],
      'title': 'Reward Redeemed',
      'description': reward['name'],
      'date': DateTime.now().toIso8601String(),
      'qrCode': 'AZZURA-${reward['id']}-${DateTime.now().millisecondsSinceEpoch}',
      'emoji': reward['image'],
    };

    final transactionsJson = prefs.getStringList('transactions') ?? [];
    transactionsJson.insert(0, jsonEncode(transaction));
    await prefs.setStringList('transactions', transactionsJson);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _primaryRed => Color(0xFF821F06);
  Color get _lightRed => Color(0xFFA43B22);
  Color get _darkRed => Color(0xFF601504);
  Color get _green => Color(0xFF7D8D36);
  Color get _cream => Color(0xFFE1D9CB);
  Color get _gold => Color(0xFFC4A46A);
  Color get _darkBrown => Color(0xFF4A3428);
  Color get _warmBrown => Color(0xFF6B4E3D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: _cream, body: _buildBody());
  }

  Widget _buildBody() {
    switch (_currentState) {
      case RewardPageState.loading:
        return _buildLoadingState();
      case RewardPageState.error:
        return _buildErrorState();
      case RewardPageState.loaded:
      case RewardPageState.redeeming:
        return _buildLoadedState();
    }
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_darkRed, _primaryRed],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_cream),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Loading Rewards...',
              style: TextStyle(
                color: _cream,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MULTISTATE: ERROR
  Widget _buildErrorState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_darkRed, _primaryRed],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: _cream),
              SizedBox(height: 16),
              Text(
                'Failed to Load Rewards',
                style: TextStyle(
                  color: _cream,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Please check your connection and try again',
                style: TextStyle(color: _cream.withOpacity(0.8), fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadRewards,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cream,
                  foregroundColor: _primaryRed,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MULTISTATE: LOADED
  Widget _buildLoadedState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: _primaryRed,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: _cream),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline, color: _cream),
              onPressed: () => _showInfoDialog(),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_darkRed, _primaryRed, _lightRed],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loyalty Rewards',
                        style: TextStyle(
                          color: _cream,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Redeem your Notti Points',
                        style: TextStyle(
                          color: _cream.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Points & Level Card
        SliverToBoxAdapter(
          child: Padding(padding: EdgeInsets.all(20), child: _buildLevelCard()),
        ),

        // Privileges Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Your Privileges',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _darkRed,
              ),
            ),
          ),
        ),

        // Rewards Grid
        SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildRewardCard(rewards[index], index),
              childCount: rewards.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_darkBrown, _warmBrown],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryRed.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(child: CustomPaint(painter: DiamondPatternPainter())),

          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Badge & Level
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wealth Level',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Text(
                            'Level $userLevel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Diamond Badge
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [_gold, _gold.withOpacity(0.7)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _gold.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('💎', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Points Display
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notti Points',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            userNottiPoints.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.stars_rounded,
                          color: _gold,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward, int index) {
    bool canRedeem = userNottiPoints >= reward['points'] && !reward['redeemed'];
    bool isLocked = !canRedeem && !reward['redeemed'];
    bool isRedeemed = reward['redeemed'];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRedeemed
                ? _green.withOpacity(0.5)
                : isLocked
                ? Colors.grey.withOpacity(0.3)
                : _primaryRed.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isRedeemed
                  ? _green.withOpacity(0.2)
                  : _primaryRed.withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: isLocked
                ? () => _showInsufficientPointsDialog(reward)
                : isRedeemed
                ? null
                : () => _showRedeemDialog(reward),
            child: Opacity(
              opacity: isLocked ? 0.5 : 1.0,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lock icon or emoji
                        if (isLocked)
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        else if (isRedeemed)
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.check_circle,
                              color: _green,
                              size: 20,
                            ),
                          ),

                        SizedBox(height: 8),

                        // Emoji
                        Center(
                          child: Text(
                            reward['image'],
                            style: TextStyle(fontSize: 48),
                          ),
                        ),

                        SizedBox(height: 12),

                        // Category tag
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            reward['category'],
                            style: TextStyle(
                              color: _primaryRed,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        // Name
                        Text(
                          reward['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 4),

                        // Description
                        Text(
                          reward['description'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Spacer(),

                        // Points
                        Row(
                          children: [
                            Icon(Icons.stars, size: 16, color: _gold),
                            SizedBox(width: 4),
                            Text(
                              '${reward['points']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _primaryRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Redeem button
                  if (canRedeem)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_primaryRed, _lightRed],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'REDEEM',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRedeemDialog(Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [_primaryRed, _lightRed]),
                  shape: BoxShape.circle,
                ),
                child: Text(reward['image'], style: TextStyle(fontSize: 48)),
              ),
              SizedBox(height: 20),
              Text(
                'Redeem Reward?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _darkRed,
                ),
              ),
              SizedBox(height: 12),
              Text(
                reward['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryRed,
                ),
              ),
              SizedBox(height: 8),
              Text(
                reward['description'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars, color: _gold, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '${reward['points']} Points',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryRed,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _processRedeem(reward);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: _primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processRedeem(Map<String, dynamic> reward) async {
    setState(() => _currentState = RewardPageState.redeeming);

    // Simulate processing
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      reward['redeemed'] = true;
      userNottiPoints -= reward['points'] as int;
      _currentState = RewardPageState.loaded;
    });

    // SAVE KE SHAREDPREFERENCES
    await _saveUserData();
    await _saveRedeemedRewards();
    await _saveTransaction(reward);

    await InboxPage.createNotification(
    type: 'reward',
    title: '🎁 Reward Redeemed!',
    message: 'You successfully redeemed ${reward['name']} for ${reward['points']} points!',
    emoji: reward['image'] ?? '🎁',
  );

    _showQRCodeDialog(reward);
  }

  void _showQRCodeDialog(Map<String, dynamic> reward) {
    String qrCode =
        'AZZURA-${reward['id']}-${DateTime.now().millisecondsSinceEpoch}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_cream, Colors.white],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 64, color: _green),
              SizedBox(height: 16),
              Text(
                'Redeemed Successfully!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _darkRed,
                ),
              ),
              SizedBox(height: 8),
              Text(
                reward['name'],
                style: TextStyle(
                  fontSize: 16,
                  color: _primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24),

              // QR Code placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primaryRed, width: 3),
                ),
                child: CustomPaint(painter: QRCodePainter(qrCode)),
              ),

              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  qrCode,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color: _darkRed,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Show this QR code to cashier',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  backgroundColor: _primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInsufficientPointsDialog(Map<String, dynamic> reward) {
    int needed = reward['points'] - userNottiPoints;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Locked',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _darkRed,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'You need $needed more Notti Points to redeem this reward.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  backgroundColor: _primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Got it',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How it works',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _darkRed,
                ),
              ),
              SizedBox(height: 16),
              _buildInfoItem('1', 'Earn Notti Points by dining at Azzura'),
              SizedBox(height: 12),
              _buildInfoItem('2', 'Redeem points for exclusive rewards'),
              SizedBox(height: 12),
              _buildInfoItem('3', 'Show QR code to cashier to claim'),
              SizedBox(height: 12),
              _buildInfoItem('4', 'Level up for better rewards!'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: _primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Got it!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: _primaryRed, shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ),
      ],
    );
  }
}

class DiamondPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final spacing = 40.0;

    for (double i = -spacing; i < size.width + spacing; i += spacing) {
      for (double j = -spacing; j < size.height + spacing; j += spacing) {
        final path = Path();
        path.moveTo(i, j - 20);
        path.lineTo(i + 20, j);
        path.lineTo(i, j + 20);
        path.lineTo(i - 20, j);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class QRCodePainter extends CustomPainter {
  final String data;

  QRCodePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final random = Random(data.hashCode);
    final blockSize = size.width / 20;

    // Generate pseudo-QR pattern
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        if (random.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(
              i * blockSize,
              j * blockSize,
              blockSize - 1,
              blockSize - 1,
            ),
            paint,
          );
        }
      }
    }

    final markerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = blockSize / 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, blockSize * 3, blockSize * 3),
      markerPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width - blockSize * 3,
        0,
        blockSize * 3,
        blockSize * 3,
      ),
      markerPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height - blockSize * 3,
        blockSize * 3,
        blockSize * 3,
      ),
      markerPaint,
    );
  }

  @override
  bool shouldRepaint(QRCodePainter oldDelegate) => data != oldDelegate.data;
}
