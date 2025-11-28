import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:azzura_rewards/constants/colors.dart';

class DealDetailPage extends StatelessWidget {
  // Menerima data deal dari halaman sebelumnya
  final Map<String, dynamic> deal;

  const DealDetailPage({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar dengan Gambar Asset
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.redDark,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              // [UPDATE] Langsung menggunakan Image.asset
              background: Image.asset(
                deal['image'], // Pastikan data yang dikirim adalah path asset (misal: 'assets/b1g1.png')
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  );
                },
              ),
            ),
          ),

          // 2. Konten Detail
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Tipe & Validitas
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (deal['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: deal['color']),
                        ),
                        child: Text(
                          deal['type'],
                          style: TextStyle(
                            color: deal['color'],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.gray),
                      const SizedBox(width: 4),
                      Text(
                        deal['valid'],
                        style: const TextStyle(color: AppColors.gray, fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Judul
                  Text(
                    deal['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Deskripsi
                  Text(
                    deal['desc'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.foreground,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bagian Kode Voucher
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.grayLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "VOUCHER CODE",
                          style: TextStyle(
                            color: AppColors.gray,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          deal['code'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.black,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: deal['code']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Code copied to clipboard!"),
                                  backgroundColor: AppColors.greenDark,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.redDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.copy),
                            label: const Text("Copy Code"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Syarat & Ketentuan (Dummy Text)
                  const Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "1. Promo valid for dine-in only at selected outlets.\n"
                    "2. Cannot be combined with other promotions.\n"
                    "3. Show this code to the cashier before payment.\n"
                    "4. Prices are subject to tax and service charge.",
                    style: TextStyle(color: AppColors.gray, height: 1.5),
                  ),
                  const SizedBox(height: 40), // Space bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}