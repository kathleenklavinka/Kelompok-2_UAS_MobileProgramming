// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';

class BrandStoryPage extends StatefulWidget {
  const BrandStoryPage({super.key});

  @override
  State<BrandStoryPage> createState() => _BrandStoryPageState();
}

class _BrandStoryPageState extends State<BrandStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.redDark,
        centerTitle: true,
        title: const Text(
          'Brand Story',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.redLight, AppColors.redDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.redDark.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      size: 32,
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'The Azzura Journey',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'From humble beginnings to a beloved culinary experience serving thousands of satisfied customers daily.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildStorySection(
              icon: Icons.store,
              title: 'Our Beginning',
              description:
                  'Notte Azzura was founded with a simple vision: to bring authentic, high-quality culinary experiences to our community. What started as a small dream has blossomed into a beloved brand that serves thousands of satisfied customers daily.',
              backgroundColor: AppColors.greenLight.withOpacity(0.1),
            ),

            const SizedBox(height: 20),

            _buildStorySection(
              icon: Icons.favorite,
              title: 'Our Values',
              description:
                  'We believe in quality, authenticity, and customer satisfaction. Every product we serve is crafted with care and passion. We\'re committed to using only the finest ingredients and maintaining the highest standards of food safety and hygiene.',
              backgroundColor: AppColors.gold.withOpacity(0.1),
            ),

            const SizedBox(height: 20),

            _buildStorySection(
              icon: Icons.rocket_launch,
              title: 'Our Mission',
              description:
                  'To create memorable dining experiences that celebrate Italian traditions while embracing modern innovation. We aim to build lasting relationships with our customers through exceptional service, quality food, and a warm atmosphere that feels like home.',
              backgroundColor: AppColors.redLight.withOpacity(0.15),
            ),

            const SizedBox(height: 32),

            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Milestones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.redDark,
                ),
              ),
            ),
            _buildTimelineItem(
              year: '2015',
              title: 'The Beginning',
              description: 'First Notte Azzura outlet opens its doors',
              isFirst: true,
            ),
            _buildTimelineItem(
              year: '2017',
              title: 'Expansion',
              description: 'Opened 3 new outlets across the city',
            ),
            _buildTimelineItem(
              year: '2019',
              title: 'Innovation',
              description: 'Launched the Azzura Rewards mobile app',
            ),
            _buildTimelineItem(
              year: '2021',
              title: 'Recognition',
              description: 'Achieved Halal certification for all outlets',
            ),
            _buildTimelineItem(
              year: '2023',
              title: 'Growing Strong',
              description: 'Reached 10+ outlets with thousands of loyal members',
              isLast: true,
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.greenLight.withOpacity(0.15),
                    AppColors.cream,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.greenLight.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 28,
                        color: AppColors.greenDark,
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'Why Choose Notte Azzura?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.redDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildWhyChooseItem('🍕 Authentic Italian flavors crafted to perfection'),
                  const SizedBox(height: 12),
                  _buildWhyChooseItem('🌟 Exceptional customer service and warm hospitality'),
                  const SizedBox(height: 12),
                  _buildWhyChooseItem('✅ Halal certified with highest quality standards'),
                  const SizedBox(height: 12),
                  _buildWhyChooseItem('🎁 Exclusive rewards and loyalty program benefits'),
                  const SizedBox(height: 12),
                  _buildWhyChooseItem('🏆 Trusted by thousands of satisfied customers'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.redLight.withOpacity(0.1),
                    AppColors.red.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.red.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 24,
                        color: AppColors.red,
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'Visit Us Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.redDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Experience the Notte Azzura difference. Visit any of our outlets to enjoy authentic Italian cuisine and exceptional service.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grayDark,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.map),
                      label: const Text('Find Our Outlets'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStorySection({
    required IconData icon,
    required String title,
    required String description,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grayLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: AppColors.greenDark,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.redDark,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grayDark,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.red, AppColors.redDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    year,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: AppColors.red.withOpacity(0.3),
                ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redDark,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grayDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12, top: 2),
          child: Text(
            '•',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.greenDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.grayDark,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
