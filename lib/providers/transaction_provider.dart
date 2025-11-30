import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TransactionProvider with ChangeNotifier {
  List<Map<String, dynamic>> _transactions = [];

  List<Map<String, dynamic>> get transactions =>
      List.unmodifiable(_transactions);

  TransactionProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsJson = prefs.getString('transactions');

    if (transactionsJson != null) {
      final List<dynamic> decoded = json.decode(transactionsJson);
      _transactions = decoded.map((item) {
        item['date'] = DateTime.parse(item['date']);
        return Map<String, dynamic>.from(item);
      }).toList();

      _transactions.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
      );
    } else {
      _addDummyData();
    }

    notifyListeners();
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> serializableTransactions = _transactions
        .map((transaction) {
          final Map<String, dynamic> serializable = Map.from(transaction);
          serializable['date'] = (transaction['date'] as DateTime)
              .toIso8601String();
          return serializable;
        })
        .toList();

    final String transactionsJson = json.encode(serializableTransactions);
    await prefs.setString('transactions', transactionsJson);
  }

  void _addDummyData() {
    _transactions = [
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
        'tier': '',
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
        'tier': '',
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
        'tier': '',
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
        'tier': '',
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
        'tier': '',
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
        'tier': '',
        'image': '👥',
      },
    ];

    _saveTransactions();
    notifyListeners();
  }

  Future<void> addTransaction({
    required String type,
    required String name,
    required String description,
    required int points,
    required String category,
    required String image,
    String tier = '',
    String status = 'completed',
  }) async {
    final transaction = {
      'id': 'trx_${DateTime.now().millisecondsSinceEpoch}',
      'type': type,
      'name': name,
      'description': description,
      'points': points,
      'date': DateTime.now(),
      'status': status,
      'category': category,
      'tier': tier,
      'image': image,
    };

    _transactions.insert(0, transaction);
    await _saveTransactions();
    notifyListeners();
  }

  List<Map<String, dynamic>> getFilteredTransactions(String filter) {
    if (filter == 'All') {
      return _transactions;
    } else if (filter == 'Rewards') {
      return _transactions.where((t) => t['type'] == 'reward').toList();
    } else if (filter == 'Merch') {
      return _transactions.where((t) => t['type'] == 'merch').toList();
    } else if (filter == 'Earned') {
      return _transactions.where((t) => t['type'] == 'earn').toList();
    }
    return _transactions;
  }

  int getTotalPointsSpent() {
    return _transactions
        .where((t) => t['points'] < 0)
        .fold(0, (sum, t) => sum + (t['points'] as int).abs());
  }

  int getTotalPointsEarned() {
    return _transactions
        .where((t) => t['points'] > 0)
        .fold(0, (sum, t) => sum + (t['points'] as int));
  }

  Future<void> clearTransactions() async {
    _transactions.clear();
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> refreshTransactions() async {
    await _loadTransactions();
  }
}