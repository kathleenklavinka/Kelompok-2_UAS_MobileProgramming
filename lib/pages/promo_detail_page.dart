import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';

class PromoDetailPage extends StatelessWidget {
  final Map<String, dynamic> promo;

  const PromoDetailPage({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    // Ambil warna utama dari list colors promo
    final Color mainColor = (promo['colors'] as List<Color>)[0];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(promo['merchant']),
        backgroundColor: mainColor, 
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Berwarna
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  // Gambar Logo Besar
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        promo['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    promo['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      promo['period'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // Konten
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promo['description'],
                    style: const TextStyle(color: AppColors.grayDark, height: 1.5, fontSize: 15),
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  const Text(
                    "Terms & Conditions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  // List Syarat
                  if (promo['terms'] != null)
                    ...(promo['terms'] as List).map((term) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, size: 16, color: mainColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                term,
                                style: const TextStyle(color: AppColors.grayDark, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Okay, Got It"),
        ),
      ),
    );
  }
}