import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:provider/provider.dart';
import '../providers/point_provider.dart';
import '../providers/transaction_provider.dart';

class MerchPage extends StatelessWidget {
  const MerchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Notte Azzura Merchandise'),
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gold, AppColors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.card_giftcard, color: AppColors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Redeem Your Points!',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Get exclusive merchandise',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Merchandise Available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
                children: [
                  _merchCard(
                    context,
                    'Preium T-Shirt',
                    500,
                    Icons.checkroom,
                    AppColors.red,
                    'Premium cotton t-shirt with Notte Azzura logo',
                    'Apparel',
                    '👕',
                  ),
                  _merchCard(
                    context,
                    'Canvas Tote Bag',
                    350,
                    Icons.shopping_bag,
                    AppColors.green,
                    'High quality canvas tote bag',
                    'Bags',
                    '👜',
                  ),
                  _merchCard(
                    context,
                    'Stainless Tumbler',
                    450,
                    Icons.local_cafe,
                    AppColors.orange,
                    '500ml stainless steel tumbler',
                    'Drinkware',
                    '☕',
                  ),
                  _merchCard(
                    context,
                    'Baseball Cap',
                    400,
                    Icons.sports_baseball,
                    AppColors.redDark,
                    'Baseball cap with embroidered logo',
                    'Apparel',
                    '🧢',
                  ),
                  _merchCard(
                    context,
                    'Ceramic Mug',
                    300,
                    Icons.coffee,
                    AppColors.greenDark,
                    'Notte Azzura exclusive ceramic mug',
                    'Drinkware',
                    '☕',
                  ),
                  _merchCard(
                    context,
                    'Premium Keychain',
                    150,
                    Icons.key,
                    AppColors.gold,
                    'Premium metal key chain',
                    'Accessories',
                    '🔑',
                  ),
                  _merchCard(
                    context,
                    'Sticker Pack',
                    100,
                    Icons.collections,
                    AppColors.info,
                    'Set of 5 waterproof stickers',
                    'Accessories',
                    '✨',
                  ),
                  _merchCard(
                    context,
                    'A5 Notebook',
                    250,
                    Icons.menu_book,
                    AppColors.warning,
                    '100 page hardcover notebook',
                    'Stationery',
                    '📔',
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _merchCard(
    BuildContext context,
    String name,
    int points,
    IconData icon,
    Color color,
    String description,
    String category,
    String emoji,
  ) {
    return GestureDetector(
      onTap: () {
        _showMerchDetail(context, name, points, icon, color, description, category, emoji);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.white, size: 40),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.stars,
                          color: AppColors.gold,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$points pts",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMerchDetail(
    BuildContext context,
    String name,
    int points,
    IconData icon,
    Color color,
    String description,
    String category,
    String emoji,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grayLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.white, size: 48),
            ),

            const SizedBox(height: 16),

            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              description,
              style: const TextStyle(fontSize: 14, color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: AppColors.gold, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "$points pts",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _redeemWithProvider(context, name, points, description, category, emoji);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Redeem Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.grayDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.grayLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _redeemWithProvider(
    BuildContext context,
    String name,
    int neededPoints,
    String description,
    String category,
    String emoji,
  ) {
    final pointProvider = context.read<PointProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    
    bool success = pointProvider.redeemPoints(neededPoints);

    if (success) {
      transactionProvider.addTransaction(
        type: 'merch',
        name: name,
        description: description,
        points: -neededPoints,
        category: category,
        image: emoji,
        tier: '',
        status: 'shipping',
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 28),
              SizedBox(width: 8),
              Text('Success!'),
            ],
          ),
          content: Text(
            'You have redeemed $neededPoints points for $name.\nMerchandise will be sent to your address within 3-5 working days.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.error, color: AppColors.red, size: 28),
              SizedBox(width: 8),
              Text('Failed!'),
            ],
          ),
          content: Text(
            'Your points are not enough to redeem $name.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Understand',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}