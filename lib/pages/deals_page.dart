import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:azzura_rewards/constants/colors.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  // Filter kategori
  final List<String> categories = ["All Deals", "Dine-in", "Delivery", "Takeaway"];
  String selectedCategory = "All Deals";

  // Data dummy
  final List<Map<String, dynamic>> deals = const [
    {
      "title": "Buy 1 Get 1 Free",
      "desc": "Buy any Large Pizza, get 1 Regular Meaty Pizza for free.",
      "code": "B1G1WEEKEND",
      "valid": "Valid until 30 Nov",
      "image": "🍕",
      "color": AppColors.redDark,
      "type": "Dine-in",
    },
    {
      "title": "Couple Package",
      "desc": "2 Regular Pizza + 2 Drinks + 1 Garlic Bread.",
      "code": "LOVERDEAL",
      "valid": "Valid daily",
      "image": "🥂",
      "color": AppColors.orange,
      "type": "Dine-in",
    },
    {
      "title": "Free Delivery",
      "desc": "Free delivery fee with min. purchase Rp 150.000.",
      "code": "FREEDELIV",
      "valid": "Weekends only",
      "image": "🛵",
      "color": AppColors.greenDark,
      "type": "Delivery",
    },
    {
      "title": "20% Off Pasta",
      "desc": "Get 20% discount for all pasta menu items.",
      "code": "ILOVEPASTA",
      "valid": "Valid until 25 Dec",
      "image": "🍝",
      "color": AppColors.gold,
      "type": "Takeaway",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDeals = selectedCategory == "All Deals"
        ? deals
        : deals.where((d) => d['type'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.redDark,
        centerTitle: true,
        title: const Text(
          'Special Offers',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.redDark, AppColors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // category filter
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: AppColors.cream,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.redDark : AppColors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? AppColors.redDark : AppColors.grayLight,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.redDark.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? AppColors.white : AppColors.grayDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // deals list
          Expanded(
            child: filteredDeals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppColors.gray.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          "No deals available for $selectedCategory",
                          style: TextStyle(color: AppColors.gray, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: filteredDeals.length,
                    itemBuilder: (context, index) {
                      final deal = filteredDeals[index];
                      return _buildDealCard(deal);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(Map<String, dynamic> deal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Upper Part (Image & Badge)
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: (deal['color'] as Color).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                // Main Emoji/Image
                Center(
                  child: Text(
                    deal['image'],
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
                // Category Badge (Top Left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.label_outline, size: 12, color: deal['color']),
                        const SizedBox(width: 4),
                        Text(
                          deal['type'],
                          style: TextStyle(
                            color: deal['color'],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Limited Time Badge (Top Right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.red.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          "Limited",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lower Part (Details & Action)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.redDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  deal['desc'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.gray,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Coupon Code Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cream.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.grayLight, 
                      style: BorderStyle.solid 
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.confirmation_number_outlined, 
                        color: AppColors.grayDark, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "VOUCHER CODE",
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.grayDark.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              deal['code'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Copy Button
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: deal['code']));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: AppColors.white),
                                  const SizedBox(width: 10),
                                  Text("Code '${deal['code']}' copied!"),
                                ],
                              ),
                              backgroundColor: AppColors.greenDark,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.redDark,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "COPY",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Valid until text
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 14, color: AppColors.gray),
                    const SizedBox(width: 6),
                    Text(
                      deal['valid'],
                      style: const TextStyle(fontSize: 12, color: AppColors.gray),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}