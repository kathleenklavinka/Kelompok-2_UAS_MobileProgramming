// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';

class NewsroomPage extends StatefulWidget {
  const NewsroomPage({super.key});

  @override
  State<NewsroomPage> createState() => _NewsroomPageState();
}

class _NewsroomPageState extends State<NewsroomPage> {
  final List<NewsItem> newsItems = [
    NewsItem(
      title: 'Notte Azzura Reaches 10+ Outlets Milestone',
      date: 'November 20, 2024',
      category: 'Expansion',
      image: Icons.store,
      content:
          'We are thrilled to announce that Notte Azzura has successfully opened its 10th outlet! This milestone marks our commitment to bringing authentic Italian cuisine to more communities across the region. Each outlet maintains our high standards of quality and service.',
    ),
    NewsItem(
      title: 'New Loyalty Program Features Launched',
      date: 'November 15, 2024',
      category: 'Updates',
      image: Icons.card_giftcard,
      content:
          'Our enhanced Azzura Rewards app now features daily check-in streaks, activity-based badges, and exclusive member-only deals. Members can now earn rewards faster and enjoy more personalized benefits tailored to their preferences.',
    ),
    NewsItem(
      title: 'Halal Certification Achieved',
      date: 'November 10, 2024',
      category: 'Certification',
      image: Icons.verified,
      content:
          'All Notte Azzura outlets have received official Halal certification, affirming our commitment to maintaining the highest standards of food preparation and quality. This certification ensures that all our products meet stringent halal requirements.',
    ),
    NewsItem(
      title: 'Sustainability Initiative: Eco-Friendly Packaging',
      date: 'November 5, 2024',
      category: 'Sustainability',
      image: Icons.eco,
      content:
          'We\'re proud to introduce eco-friendly packaging across all outlets. By using sustainable materials, we\'re reducing our environmental footprint while maintaining the premium quality of our products. Thank you for supporting our green initiative!',
    ),
    NewsItem(
      title: 'Holiday Special Menu Now Available',
      date: 'October 28, 2024',
      category: 'Menu',
      image: Icons.restaurant_menu,
      content:
          'Celebrate the festive season with our special holiday menu featuring limited-time offerings. From traditional Italian dishes with a festive twist to signature beverages, there\'s something special for everyone. Available at all outlets while supplies last.',
    ),
    NewsItem(
      title: 'Customer Appreciation Week Recap',
      date: 'October 15, 2024',
      category: 'Community',
      image: Icons.people,
      content:
          'Thank you for making Customer Appreciation Week a huge success! Over 5,000 customers participated in our special promotions and earned double rewards. Your loyalty and support mean the world to us!',
    ),
    NewsItem(
      title: 'Mobile App Update: Version 4.0 Released',
      date: 'October 1, 2024',
      category: 'Technology',
      image: Icons.phone_android,
      content:
          'Download the latest version of the Azzura Rewards app featuring an improved user interface, faster loading times, and new features for a better mobile experience. Available on iOS and Android platforms.',
    ),
    NewsItem(
      title: 'Training Program for Staff Excellence',
      date: 'September 20, 2024',
      category: 'Company',
      image: Icons.school,
      content:
          'We\'ve launched a comprehensive training program to ensure our staff maintains exceptional service standards. Our team members are now equipped with the latest customer service techniques and product knowledge.',
    ),
  ];

  int? expandedIndex;
  String selectedCategory = 'All';

  List<String> get categories {
    final cats = {'All'};
    for (var item in newsItems) {
      cats.add(item.category);
    }
    return cats.toList();
  }

  List<NewsItem> get filteredNews {
    if (selectedCategory == 'All') {
      return newsItems;
    }
    return newsItems.where((item) => item.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.redDark,
        centerTitle: true,
        title: const Text(
          'Newsroom',
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
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  Icon(
                    Icons.newspaper,
                    size: 28,
                    color: AppColors.greenDark,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Latest News & Updates',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.redDark,
                          ),
                        ),

                        const SizedBox(height: 4),
                        
                        Text(
                          'Stay informed about Notte Azzura developments',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grayDark,
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
              'Categories',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.redDark,
              ),
            ),

            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      backgroundColor: AppColors.white,
                      selectedColor: AppColors.red,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.grayDark,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.red
                            : AppColors.grayLight.withOpacity(0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            if (filteredNews.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 48,
                        color: AppColors.grayDark.withOpacity(0.5),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'No news in this category',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grayDark,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredNews.length,
                itemBuilder: (context, index) {
                  final news = filteredNews[index];
                  final isExpanded = expandedIndex == index;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.grayLight.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            expandedIndex = isExpanded ? null : index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.redLight.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      news.image,
                                      size: 22,
                                      color: AppColors.red,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.gold
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            news.category,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.gold,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          news.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.redDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: AppColors.greenDark,
                                    size: 24,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                news.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grayDark.withOpacity(0.7),
                                ),
                              ),
                              if (isExpanded) ...[

                                const SizedBox(height: 12),

                                Container(
                                  height: 1,
                                  color: AppColors.grayLight.withOpacity(0.3),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  news.content,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.grayDark,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                        Icons.mail_outline,
                        size: 24,
                        color: AppColors.red,
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'Stay Updated',
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
                    'Get the latest news, promotions, and updates delivered to your inbox. Subscribe to our newsletter today!',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grayDark,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Subscribe feature coming soon!'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.notifications),
                      label: const Text('Subscribe to Newsletter'),
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
}

class NewsItem {
  final String title;
  final String date;
  final String category;
  final IconData image;
  final String content;

  NewsItem({
    required this.title,
    required this.date,
    required this.category,
    required this.image,
    required this.content,
  });
}
