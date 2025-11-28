import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';
import 'package:azzura_rewards/pages/promo_detail_page.dart';

class PromosPage extends StatefulWidget {
  const PromosPage({super.key});

  @override
  State<PromosPage> createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> {
  final List<Map<String, dynamic>> promos = [
    {
      "title": "Cashback 50% Pakai GoPay",
      "merchant": "GoPay",
      "period": "Valid until 30 Nov",
      "description": "Dapatkan cashback 50% maksimal Rp 20.000...",
      "colors": [const Color(0xFF00AA13), const Color(0xFF00C318)],
      "image": "assets/free.png",
      "terms": ["Min. transaksi Rp 40.000", "Berlaku Dine-in"]
    },
    {
      "title": "Diskon Rp 15rb Pakai OVO",
      "merchant": "OVO",
      "period": "1-15 Dec 2024",
      "description": "Potongan langsung Rp 15.000 dengan minimal...",
      "colors": [const Color(0xFF4C3494), const Color(0xFF6946C6)],
      "image": "assets/cp.png",
      "terms": ["Min. transaksi Rp 100.000"]
    },
    {
      "title": "Pay 1 Get 2 with Mandiri",
      "merchant": "Bank Mandiri",
      "period": "Weekend Only",
      "description": "Beli 1 menu Main Course apa saja...",
      "colors": [const Color(0xFF003D79), const Color(0xFF005CAA)],
      "image": "assets/buy1get1.png",
      "terms": ["Khusus Sabtu & Minggu"]
    },
    {
      "title": "Diskon 20% Kartu BCA",
      "merchant": "BCA",
      "period": "Every Monday",
      "description": "Senin makin hemat dengan diskon...",
      "colors": [const Color(0xFF005CAA), const Color(0xFF007AE6)],
      "image": "assets/PASTA.png",
      "terms": ["Min. transaksi Rp 200.000"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: AppBar(
        title: const Text(
          "Partner Promo", 
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: AppColors.redDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: promos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return _buildPremiumCard(promos[index]);
        },
      ),
    );
  }

  Widget _buildPremiumCard(Map<String, dynamic> promo) {
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
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: promo['colors'],
          ),
          boxShadow: [
            BoxShadow(
              color: (promo['colors'][0] as Color).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: CircleAvatar(
                radius: 90,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -40,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withOpacity(0.08),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Kolom Teks
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge Merchant
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2), 
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            promo['merchant'].toString().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        
                        // Judul
                        Text(
                          promo['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const Spacer(),

                        Row(
                          children: [
                            const Icon(Icons.access_time_filled, color: Colors.white70, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              promo['period'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: 1,
                    height: double.infinity,
                    child: CustomPaint(
                      painter: DashedLinePainter(),
                    ),
                  ),

                  // Kolom Gambar & Tombol
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Gambar dalam Lingkaran
                      Container(
                        padding: const EdgeInsets.all(4), 
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              promo['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Icon(
                                Icons.image_not_supported,
                                color: promo['colors'][0],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Tombol "View"
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "View",
                              style: TextStyle(
                                color: promo['colors'][0], 
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 12,
                              color: promo['colors'][0],
                            ),
                          ],
                        ),
                      )
                    ],
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

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}