import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

enum HistoryPageState { loading, loaded, empty, error }

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  HistoryPageState _currentState = HistoryPageState.loading;

  String _selectedFilter = 'All';

  int totalPointsEarned = 0;
  int totalPointsSpent = 0;
  int currentBalance = 2450;

  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _currentState = HistoryPageState.loading);

    try {
      final prefs = await SharedPreferences.getInstance();

      currentBalance = prefs.getInt('userNottiPoints') ?? 2450;

      final transactionsJson = prefs.getStringList('transactions') ?? [];
      transactions = transactionsJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();

      transactions.sort(
        (a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
      );

      totalPointsEarned = transactions
          .where((t) => t['type'] == 'earned')
          .fold(0, (sum, t) => sum + (t['points'] as int));

      totalPointsSpent = transactions
          .where((t) => t['type'] == 'redeemed')
          .fold(0, (sum, t) => sum + (t['points'] as int));

      await Future.delayed(Duration(seconds: 1));

      if (transactions.isEmpty) {
        setState(() => _currentState = HistoryPageState.empty);
      } else {
        setState(() => _currentState = HistoryPageState.loaded);
        _animationController.forward();
      }
    } catch (e) {
      setState(() => _currentState = HistoryPageState.error);
    }
  }

  Future<void> _addDummyTransaction() async {
    final prefs = await SharedPreferences.getInstance();

    final dishes = [
      {'name': 'Carbonara Pasta', 'emoji': '🍝', 'points': 450},
      {'name': 'Margherita Pizza', 'emoji': '🍕', 'points': 550},
      {'name': 'Grilled Salmon', 'emoji': '🐟', 'points': 650},
      {'name': 'Wagyu Steak', 'emoji': '🥩', 'points': 850},
      {'name': 'Caesar Salad', 'emoji': '🥗', 'points': 250},
    ];

    final selectedDish = dishes[Random().nextInt(dishes.length)];

    final dummy = {
      'id': 'trans_${DateTime.now().millisecondsSinceEpoch}',
      'type': 'earned',
      'points': selectedDish['points'],
      'title': 'Dining at Azzura',
      'description': selectedDish['name'],
      'date': DateTime.now().toIso8601String(),
      'qrCode': 'AZZURA-EARN-${DateTime.now().millisecondsSinceEpoch}',
      'emoji': selectedDish['emoji'],
    };

    transactions.insert(0, dummy);

    final transactionsJson = transactions.map((t) => jsonEncode(t)).toList();
    await prefs.setStringList('transactions', transactionsJson);

    _loadTransactions();
  }

  Future<void> _clearAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('transactions');
    _loadTransactions();
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
      case HistoryPageState.loading:
        return _buildLoadingState();
      case HistoryPageState.error:
        return _buildErrorState();
      case HistoryPageState.empty:
        return _buildEmptyState();
      case HistoryPageState.loaded:
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
              'Loading History...',
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
                'Failed to Load History',
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
                onPressed: _loadTransactions,
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

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_cream, Colors.white],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_darkRed, _primaryRed]),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: _cream),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Transaction History',
                    style: TextStyle(
                      color: _cream,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _primaryRed.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: _primaryRed.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'No Transactions Yet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _darkRed,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Start dining at Azzura to earn points\nor redeem rewards to see your history here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _addDummyTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.restaurant, color: Colors.white),
                        label: Text(
                          'Simulate Dining',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState() {
    List<Map<String, dynamic>> filteredTransactions = transactions;

    if (_selectedFilter != 'All') {
      String filterType = _selectedFilter == 'Earned' ? 'earned' : 'redeemed';
      filteredTransactions = transactions
          .where((t) => t['type'] == filterType)
          .toList();
    }

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
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: _cream),
              onSelected: (value) {
                if (value == 'add') {
                  _addDummyTransaction();
                } else if (value == 'clear') {
                  _showClearDialog();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'add',
                  child: Row(
                    children: [
                      Icon(Icons.restaurant, size: 20, color: _green),
                      SizedBox(width: 12),
                      Text('Simulate Dining'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Clear All', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
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
                        'Transaction History',
                        style: TextStyle(
                          color: _cream,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Track your points activity',
                        style: TextStyle(
                          color: _cream.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: _buildStatsCards(),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _buildFilterChips(),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: filteredTransactions.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.filter_list_off,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No ${_selectedFilter.toLowerCase()} transactions',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildTransactionCard(
                      filteredTransactions[index],
                      index,
                    ),
                    childCount: filteredTransactions.length,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Earned',
            totalPointsEarned,
            _green,
            Icons.trending_up,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Spent',
            totalPointsSpent,
            _primaryRed,
            Icons.trending_down,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                '+$value',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        _buildFilterChip('All'),
        SizedBox(width: 8),
        _buildFilterChip('Earned'),
        SizedBox(width: 8),
        _buildFilterChip('Redeemed'),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _primaryRed : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryRed : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction, int index) {
    bool isEarned = transaction['type'] == 'earned';
    DateTime date = DateTime.parse(transaction['date']);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showTransactionDetail(transaction),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isEarned
                            ? [_green, _green.withOpacity(0.7)]
                            : [_primaryRed, _lightRed],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        transaction['emoji'] ?? (isEarned ? '💰' : '🎁'),
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          transaction['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          _formatDate(date),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isEarned ? '+' : '-'}${transaction['points']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isEarned ? _green : _primaryRed,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isEarned
                              ? _green.withOpacity(0.1)
                              : _primaryRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isEarned ? 'Earned' : 'Spent',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isEarned ? _green : _primaryRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    bool isEarned = transaction['type'] == 'earned';
    DateTime date = DateTime.parse(transaction['date']);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isEarned
                        ? [_green, _green.withOpacity(0.7)]
                        : [_primaryRed, _lightRed],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  transaction['emoji'] ?? (isEarned ? '💰' : '🎁'),
                  style: TextStyle(fontSize: 48),
                ),
              ),
              SizedBox(height: 20),
              Text(
                transaction['title'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _darkRed,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                transaction['description'],
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Points',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${isEarned ? '+' : '-'}${transaction['points']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isEarned ? _green : _primaryRed,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction ID',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          transaction['id'].toString().substring(6, 16),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (transaction['qrCode'] != null) ...[
                SizedBox(height: 20),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _primaryRed, width: 2),
                  ),
                  child: CustomPaint(
                    painter: QRCodePainter(transaction['qrCode']),
                  ),
                ),
              ],
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryRed,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
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

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear All Transactions?'),
        content: Text(
          'This will delete all transaction history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllTransactions();
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryRed),
            child: Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
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
