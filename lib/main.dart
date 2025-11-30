import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'pages/home_page.dart';
import 'providers/point_provider.dart';
import 'providers/tier_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PointProvider()),
        ChangeNotifierProvider(create: (_) => TierProvider()),
      ],
      child: const LoyaltyApp(),
    ),
  );
}

class LoyaltyApp extends StatelessWidget {
  const LoyaltyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notte Azzura Point',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.redDark,
          primary: AppColors.redDark,
          secondary: AppColors.gold,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}