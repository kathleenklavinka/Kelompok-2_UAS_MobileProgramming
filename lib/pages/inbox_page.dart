import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  static Future<void> createNotification({
    required String type,
    required String title,
    required String message,
    required String emoji,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final notifJson = prefs.getStringList('notifications') ?? [];
    
    final newNotif = {
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
      'type': type,
      'title': title,
      'message': message,
      'date': DateTime.now().toIso8601String(),
      'read': false,
      'emoji': emoji,
    };
    
    notifJson.insert(0, jsonEncode(newNotif));
    
    if (notifJson.length > 50) {
      notifJson.removeRange(50, notifJson.length);
    }
    
    await prefs.setStringList('notifications', notifJson);
  }

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> notifications = [];
  String selectedFilter = 'All';
  bool isLoading = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Color get _primaryRed => Color(0xFF821F06);
  Color get _lightRed => Color(0xFFA43B22);
  Color get _darkRed => Color(0xFF601504);
  Color get _green => Color(0xFF7D8D36);
  Color get _cream => Color(0xFFE1D9CB);
  Color get _gold => Color(0xFFC4A46A);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadNotifications();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _loadNotifications() async {
    setState(() => isLoading = true);

    await Future.delayed(Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    final notifJson = prefs.getStringList('notifications') ?? [];

    if (notifJson.isEmpty) {
      notifications = [
        {
          'id': 'notif_1',
          'type': 'promo',
          'title': '🎉 New Deal Alert!',
          'message': 'Get 50% off on Margherita Pizza this weekend only!',
          'date': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
          'read': false,
          'emoji': '🍕',
        },
        {
          'id': 'notif_2',
          'type': 'points',
          'title': '⭐ Points Earned!',
          'message': 'You earned 150 Notti Points from your recent purchase.',
          'date': DateTime.now().subtract(Duration(hours: 5)).toIso8601String(),
          'read': false,
          'emoji': '⭐',
        },
        {
          'id': 'notif_3',
          'type': 'reward',
          'title': '🎁 Reward Unlocked!',
          'message': 'Congratulations! You can now redeem Premium Steak.',
          'date': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
          'read': true,
          'emoji': '🎁',
        },
        {
          'id': 'notif_4',
          'type': 'reminder',
          'title': '⏰ Points Expiring Soon',
          'message': '500 points will expire in 7 days. Use them before they\'re gone!',
          'date': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
          'read': true,
          'emoji': '⏰',
        },
        {
          'id': 'notif_5',
          'type': 'update',
          'title': '✨ App Update Available',
          'message': 'New features added! Update now for better experience.',
          'date': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
          'read': true,
          'emoji': '✨',
        },
        {
          'id': 'notif_6',
          'type': 'promo',
          'title': '🔥 Flash Sale!',
          'message': 'Limited time: Buy 1 Get 1 Free on all pasta dishes!',
          'date': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
          'read': true,
          'emoji': '🔥',
        },
      ];
      await _saveNotifications();
    } else {
      notifications = notifJson.map((n) => jsonDecode(n) as Map<String, dynamic>).toList();
    }

    setState(() => isLoading = false);
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notifJson = notifications.map((n) => jsonEncode(n)).toList();
    await prefs.setStringList('notifications', notifJson);
  }

  void _markAsRead(String id) async {
    setState(() {
      final index = notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        notifications[index]['read'] = true;
      }
    });
    await _saveNotifications();
  }

  void _markAllAsRead() async {
    setState(() {
      for (var notif in notifications) {
        notif['read'] = true;
      }
    });
    await _saveNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: _green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _deleteNotification(String id) async {
    setState(() {
      notifications.removeWhere((n) => n['id'] == id);
    });
    await _saveNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification deleted'),
        backgroundColor: _primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _clearAll() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _cream,
        title: Text(
          'Clear All Notifications?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _darkRed,
          ),
        ),
        content: Text(
          'This action cannot be undone.',
          style: TextStyle(color: _green),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              setState(() => notifications.clear());
              await _saveNotifications();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All notifications cleared'),
                  backgroundColor: _primaryRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Text('Clear All', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'All') return notifications;
    if (selectedFilter == 'Unread') {
      return notifications.where((n) => n['read'] == false).toList();
    }
    return notifications.where((n) => n['type'] == selectedFilter.toLowerCase()).toList();
  }

  int get unreadCount => notifications.where((n) => n['read'] == false).length;

  String formatTime(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'promo':
        return _primaryRed;
      case 'points':
        return _gold;
      case 'reward':
        return _green;
      case 'reminder':
        return Colors.orange;
      case 'update':
        return Colors.blue;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type) {
      case 'promo':
        return Icons.local_offer;
      case 'points':
        return Icons.stars;
      case 'reward':
        return Icons.card_giftcard;
      case 'reminder':
        return Icons.notifications_active;
      case 'update':
        return Icons.system_update;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryRed,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _cream),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inbox',
              style: TextStyle(
                color: _cream,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount unread',
                style: TextStyle(
                  color: _cream.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: _cream),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'mark_all') {
                  _markAllAsRead();
                } else if (value == 'clear_all') {
                  _clearAll();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'mark_all',
                  child: Row(
                    children: [
                      Icon(Icons.done_all, color: _green, size: 20),
                      SizedBox(width: 12),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, color: _primaryRed, size: 20),
                      SizedBox(width: 12),
                      Text('Clear all'),
                    ],
                  ),
                ),
              ],
            ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_darkRed, _primaryRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryRed),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading notifications...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', Icons.inbox),
                        SizedBox(width: 8),
                        _buildFilterChip('Unread', Icons.mark_email_unread),
                        SizedBox(width: 8),
                        _buildFilterChip('Promo', Icons.local_offer),
                        SizedBox(width: 8),
                        _buildFilterChip('Points', Icons.stars),
                        SizedBox(width: 8),
                        _buildFilterChip('Reward', Icons.card_giftcard),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: filteredNotifications.isEmpty
                      ? _buildEmptyState()
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: filteredNotifications.length,
                              itemBuilder: (context, index) {
                                final notif = filteredNotifications[index];
                                return _buildNotificationCard(notif, index);
                              },
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [_primaryRed, _lightRed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryRed : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif, int index) {
    final isRead = notif['read'] == true;
    final type = notif['type'] as String;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Dismissible(
        key: Key(notif['id']),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryRed, _darkRed],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white, size: 24),
        ),
        onDismissed: (_) => _deleteNotification(notif['id']),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : _lightRed.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead
                  ? Colors.grey[300]!
                  : _primaryRed.withOpacity(0.3),
              width: isRead ? 1 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (!isRead) _markAsRead(notif['id']);
                _showNotificationDetail(notif);
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            getTypeColor(type),
                            getTypeColor(type).withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: getTypeColor(type).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          notif['emoji'] ?? '📢',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notif['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: _darkRed,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _primaryRed,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            notif['message'],
                            style: TextStyle(
                              fontSize: 13,
                              color: _green,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                formatTime(notif['date']),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: getTypeColor(type).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  type.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: getTypeColor(type),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          Text(
            selectedFilter == 'All'
                ? 'No Notifications Yet'
                : 'No $selectedFilter Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _darkRed,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'We\'ll notify you when something new arrives',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetail(Map<String, dynamic> notif) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        getTypeColor(notif['type']),
                        getTypeColor(notif['type']).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    notif['emoji'] ?? '📢',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _darkRed,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        formatTime(notif['date']),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              notif['message'],
              style: TextStyle(
                fontSize: 15,
                color: _green,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteNotification(notif['id']);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: _primaryRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: _primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.grey[600],
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}