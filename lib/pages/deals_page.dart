import 'package:flutter/material.dart';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  final List<Map<String, String>> dealsData = const [
    {
      "title": "Beli 1 Gratis 1 Pizza",
      "description": "Beli 1 Large Pizza, dapatkan 1 Regular Pizza gratis!",
      "imageUrl": "https://placehold.co/600x400/F44336/FFFFFF?text=Buy+1+Get+1",
    },
    {
      "title": "Paket Hemat Berdua",
      "description": "2 Regular Pizza + 2 Minuman hanya Rp 99.000",
      "imageUrl": "https://placehold.co/600x400/E91E63/FFFFFF?text=Paket+Hemat",
    },
    {
      "title": "Gratis Ongkir",
      "description": "Nikmati gratis ongkir tanpa min. pembelian.",
      "imageUrl": "https://placehold.co/600x400/9C27B0/FFFFFF?text=Gratis+Ongkir",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penawaran Spesial'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dealsData.length,
        itemBuilder: (context, index) {
          final deal = dealsData[index];
          return PromoCard(
            title: deal['title']!,
            description: deal['description']!,
            imageUrl: deal['imageUrl']!,
          );
        },
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const PromoCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('LIHAT DETAIL', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}