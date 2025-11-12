import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // dummy user sementara
  late User currentUser;

  // dummy sementara
  @override
  void initState() {
    super.initState();
    currentUser = User(
      id: '001',
      name: 'Maria Rossi',
      phone: '+62 812 3456 7890',
      email: 'maria.rossi@email.com',
      nottiPoints: 1250,
      totalSpending: 750000,
      tier: MemberTier.mattina,
      savedAddresses: ['Jl. Sudirman No. 123, Jakarta'],
      joinDate: DateTime(2024, 1, 15),
    );
  }

  void _editProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditProfileSheet(
        user: currentUser,
        onSave: (name, phone) {
          setState(() {
            currentUser.name = name;
            currentUser.phone = phone;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.red,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.red, AppColors.redDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      // Profile Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(color: AppColors.gold, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            currentUser.tier.emoji,
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        currentUser.name,
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        currentUser.phone,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.cream,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () => _editProfile(context),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 16),

                // Tier Status Card
                _buildTierCard(),

                SizedBox(height: 24),

                // General Section
                _buildSection(
                  title: 'General',
                  items: [
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Saved Address',
                      onTap: () => _navigateTo(context, 'Saved Address'),
                    ),
                    _MenuItem(
                      icon: Icons.help_outline,
                      title: 'FAQ',
                      onTap: () => _navigateTo(context, 'FAQ'),
                    ),
                    _MenuItem(
                      icon: Icons.chat_bubble_outline,
                      title: 'Live Chat',
                      onTap: () => _navigateTo(context, 'Live Chat'),
                    ),
                    _MenuItem(
                      icon: Icons.phone_outlined,
                      title: 'Contact Us',
                      onTap: () => _navigateTo(context, 'Contact Us'),
                    ),
                    _MenuItem(
                      icon: Icons.star_outline,
                      title: 'Rate Our App',
                      onTap: () => _showRatingDialog(context),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // About Us Section
                _buildSection(
                  title: 'About Us',
                  items: [
                    _MenuItem(
                      icon: Icons.auto_stories_outlined,
                      title: 'Brand Story',
                      onTap: () => _navigateTo(context, 'Brand Story'),
                    ),
                    _MenuItem(
                      icon: Icons.restaurant_outlined,
                      title: 'Notte Azzura Story',
                      onTap: () => _navigateTo(context, 'Notte Azzura Story'),
                    ),
                    _MenuItem(
                      icon: Icons.volunteer_activism_outlined,
                      title: 'CSR',
                      onTap: () => _navigateTo(context, 'CSR'),
                    ),
                    _MenuItem(
                      icon: Icons.newspaper_outlined,
                      title: 'Newsroom',
                      onTap: () => _navigateTo(context, 'Newsroom'),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Policy Section
                _buildSection(
                  title: 'Policy',
                  items: [
                    _MenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms of Use',
                      onTap: () => _navigateTo(context, 'Terms of Use'),
                    ),
                    _MenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () => _navigateTo(context, 'Privacy Policy'),
                    ),
                    _MenuItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () => _showLogoutDialog(context),
                      isDestructive: true,
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // Versi Aplikasi
                Text(
                  'Azzura Rewards v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cream, AppColors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
                    'Current Tier',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        currentUser.tier.emoji,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(width: 8),
                      Text(
                        currentUser.tier.name,
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentUser.nottiPoints} pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.redDark,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (currentUser.tier != MemberTier.notte) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress to ${_getNextTier(currentUser.tier).name}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                    Text(
                      '${(currentUser.getProgressToNextTier() * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: currentUser.getProgressToNextTier(),
                    backgroundColor: AppColors.grayLight,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
                    minHeight: 8,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${currentUser.getNextTierAmount()} more to unlock',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.grayLight),
          ...items.map((item) => _buildMenuItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grayLight.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.isDestructive
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.cream.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: item.isDestructive ? AppColors.error : AppColors.red,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: item.isDestructive ? AppColors.error : AppColors.foreground,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.gray,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  MemberTier _getNextTier(MemberTier currentTier) {
    switch (currentTier) {
      case MemberTier.mattina:
        return MemberTier.pomeriggio;
      case MemberTier.pomeriggio:
        return MemberTier.notte;
      case MemberTier.notte:
        return MemberTier.notte;
    }
  }

  void _navigateTo(BuildContext context, String page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _DetailPage(title: page),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rate Our App',
          style: TextStyle(fontFamily: 'Playfair Display'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('How do you like Azzura Rewards?'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: AppColors.gold,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thank you for your rating!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: TextStyle(fontFamily: 'Playfair Display'),
        ),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement logout logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}

// Edit Profile Bottom Sheet
class _EditProfileSheet extends StatefulWidget {
  final User user;
  final Function(String name, String phone) onSave;

  const _EditProfileSheet({
    required this.user,
    required this.onSave,
  });

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.red),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.red),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _nameController.text,
                  _phoneController.text,
                );
              },
              child: Text('Save Changes'),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

// Detail Page untuk item menu
class _DetailPage extends StatelessWidget {
  final String title;

  const _DetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 64,
                color: AppColors.gray,
              ),
              SizedBox(height: 16),
              Text(
                '$title',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This page is under construction',
                style: TextStyle(
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}