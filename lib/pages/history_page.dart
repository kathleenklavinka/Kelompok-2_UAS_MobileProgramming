import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> transactions = [
    {
      'id': 'trx_001',
      'type': 'reward',
      'name': 'Margherita Pizza',
      'description': 'Classic tomato & cheese',
      'points': -2500,
      'date': DateTime(2024, 11, 28, 14, 30),
      'status': 'completed',
      'category': 'Pizza',
      'tier': 'Gold',
      'image': '🍕',
    },
    {
      'id': 'trx_002',
      'type': 'merch',
      'name': 'T-Shirt Premium',
      'description': 'T-shirt katun premium dengan logo',
      'points': -500,
      'date': DateTime(2024, 11, 27, 10, 15),
      'status': 'shipping',
      'category': 'Apparel',
      'image': '👕',
    },
    {
      'id': 'trx_003',
      'type': 'reward',
      'name': 'Carbonara Pasta',
      'description': 'Creamy & delicious',
      'points': -1800,
      'date': DateTime(2024, 11, 26, 18, 45),
      'status': 'completed',
      'category': 'Pasta',
      'tier': 'Silver',
      'image': '🍝',
    },
    {
      'id': 'trx_004',
      'type': 'earn',
      'name': 'Purchase Points',
      'description': 'Pembelian di outlet',
      'points': 150,
      'date': DateTime(2024, 11, 25, 12, 20),
      'status': 'completed',
      'category': 'Points',
      'image': '⭐',
    },
    {
      'id': 'trx_005',
      'type': 'merch',
      'name': 'Tumbler Stainless',
      'description': 'Tumbler 500ml stainless steel',
      'points': -450,
      'date': DateTime(2024, 11, 24, 16, 10),
      'status': 'completed',
      'category': 'Drinkware',
      'image': '☕',
    },
    {
      'id': 'trx_006',
      'type': 'reward',
      'name': 'Garlic Bread',
      'description': 'With butter & herbs',
      'points': -800,
      'date': DateTime(2024, 11, 23, 13, 30),
      'status': 'completed',
      'category': 'Side Dish',
      'tier': 'Bronze',
      'image': '🥖',
    },
    {
      'id': 'trx_007',
      'type': 'earn',
      'name': 'Birthday Bonus',
      'description': 'Special birthday reward',
      'points': 500,
      'date': DateTime(2024, 11, 22, 9, 0),
      'status': 'completed',
      'category': 'Bonus',
      'image': '🎂',
    },
    {
      'id': 'trx_008',
      'type': 'merch',
      'name': 'Tote Bag Canvas',
      'description': 'Tote bag canvas berkualitas tinggi',
      'points': -350,
      'date': DateTime(2024, 11, 20, 11, 45),
      'status': 'completed',
      'category': 'Bags',
      'image': '👜',
    },
    {
      'id': 'trx_009',
      'type': 'reward',
      'name': 'Pepperoni Pizza',
      'description': 'With extra cheese',
      'points': -3000,
      'date': DateTime(2024, 11, 19, 19, 15),
      'status': 'completed',
      'category': 'Pizza',
      'tier': 'Gold',
      'image': '🍕',
    },
    {
      'id': 'trx_010',
      'type': 'earn',
      'name': 'Referral Bonus',
      'description': 'Dari mengajak teman',
      'points': 300,
      'date': DateTime(2024, 11, 18, 15, 30),
      'status': 'completed',
      'category': 'Bonus',
      'image': '👥',
    },
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilter == 'All') {
      return transactions;
    } else if (selectedFilter == 'Rewards') {
      return transactions.where((t) => t['type'] == 'reward').toList();
    } else if (selectedFilter == 'Merch') {
      return transactions.where((t) => t['type'] == 'merch').toList();
    } else {
      return transactions.where((t) => t['type'] == 'earn').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppColors.red,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.red, AppColors.redLight],
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem(
                  'Total Transaksi',
                  '${transactions.length}',
                  Icons.receipt_long,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.white.withOpacity(0.3),
                ),
                _summaryItem(
                  'Points Terpakai',
                  '${_getTotalPointsSpent()}',
                  Icons.star,
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip('All'),
                const SizedBox(width: 8),
                _filterChip('Rewards'),
                const SizedBox(width: 8),
                _filterChip('Merch'),
                const SizedBox(width: 8),
                _filterChip('Earned'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: filteredTransactions.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return _transactionCard(transaction);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.red : AppColors.grayLight,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.red.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.grayDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _transactionCard(Map<String, dynamic> transaction) {
    final isEarned = transaction['type'] == 'earn';
    final points = transaction['points'] as int;
    final pointsColor = isEarned ? AppColors.success : AppColors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTransactionDetail(transaction),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getTypeColor(transaction['type']).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      transaction['image'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction['description'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.grayDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _statusBadge(transaction['status']),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(transaction['date']),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isEarned ? '+' : ''}$points',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: pointsColor,
                      ),
                    ),
                    const Text(
                      'pts',
                      style: TextStyle(fontSize: 12, color: AppColors.gray),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'completed':
        bgColor = AppColors.success.withOpacity(0.15);
        textColor = AppColors.success;
        label = 'Selesai';
        break;
      case 'shipping':
        bgColor = AppColors.warning.withOpacity(0.15);
        textColor = AppColors.warning;
        label = 'Dikirim';
        break;
      case 'pending':
        bgColor = AppColors.info.withOpacity(0.15);
        textColor = AppColors.info;
        label = 'Pending';
        break;
      default:
        bgColor = AppColors.grayLight;
        textColor = AppColors.grayDark;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: AppColors.grayLight),
          const SizedBox(height: 16),
          const Text(
            'Belum ada transaksi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.grayDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mulai tukar poin dengan reward atau merchandise',
            style: TextStyle(fontSize: 14, color: AppColors.gray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'reward':
        return AppColors.orange;
      case 'merch':
        return AppColors.green;
      case 'earn':
        return AppColors.gold;
      default:
        return AppColors.gray;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  int _getTotalPointsSpent() {
    return transactions
        .where((t) => t['points'] < 0)
        .fold(0, (sum, t) => sum + (t['points'] as int).abs());
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grayLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _getTypeColor(transaction['type']).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    transaction['image'],
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Detail Transaksi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 16),

            _detailRow('ID Transaksi', transaction['id']),
            _detailRow('Item', transaction['name']),
            _detailRow('Deskripsi', transaction['description']),
            _detailRow('Kategori', transaction['category']),
            if (transaction.containsKey('tier'))
              _detailRow('Tier', transaction['tier']),
            _detailRow('Points', '${transaction['points']} pts'),
            _detailRow('Status', transaction['status']),
            _detailRow('Tanggal', _formatDateTime(transaction['date'])),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.gray),
            ),
          ),
          const Text(': ', style: TextStyle(color: AppColors.gray)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}