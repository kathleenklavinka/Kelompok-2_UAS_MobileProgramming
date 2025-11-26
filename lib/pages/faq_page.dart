// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<FAQItem> faqs = [
    FAQItem(
      question: 'How do I earn rewards points?',
      answer:
          'You can earn rewards points by making purchases at any Notte Azzura outlet. For every purchase, you\'ll automatically receive points. You can also earn bonus points by completing activities, referring friends, and maintaining your daily check-in streak.',
    ),
    FAQItem(
      question: 'How can I redeem my points?',
      answer:
          'Once you have accumulated enough points, you can redeem them in the Rewards section of the app. You can choose from various reward options including discounts, free items, and special promotions. Simply tap on a reward to redeem it.',
    ),
    FAQItem(
      question: 'Do my points expire?',
      answer:
          'Your rewards points do not expire as long as your account remains active. However, we recommend redeeming your points regularly to enjoy the exclusive rewards and promotions available.',
    ),
    FAQItem(
      question: 'What are badges and how do I unlock them?',
      answer:
          'Badges are special achievements that recognize your loyalty and engagement. You can unlock badges by completing various activities such as making your first purchase, referring friends, or maintaining a daily check-in streak. Each badge has unique requirements.',
    ),
    FAQItem(
      question: 'How does the daily check-in streak work?',
      answer:
          'Simply tap the "Check-in" button daily to maintain your streak. A 5-day streak will unlock the "5 Day Streak" badge and earn you bonus points. Keep your streak alive by checking in every day!',
    ),
    FAQItem(
      question: 'Can I save multiple delivery addresses?',
      answer:
          'Yes! You can save multiple delivery addresses for convenience. Go to Saved Address in the profile menu to add, edit, or delete addresses. You can label them as Home, Office, Parents, etc. for easy identification.',
    ),
    FAQItem(
      question: 'How do I update my profile information?',
      answer:
          'You can update your profile by tapping the edit button in your profile header. You can change your name, phone number, and profile picture. All changes are saved immediately.',
    ),
    FAQItem(
      question: 'What should I do if I forgot my password?',
      answer:
          'If you forget your password, you can use the "Forgot Password" option on the login screen. Enter your email address and follow the instructions sent to your email to reset your password.',
    ),
    FAQItem(
      question: 'How do I contact customer support?',
      answer:
          'You can reach our customer support team through the "Live Chat" option in the profile menu or visit "Contact Us" for other contact methods. We\'re available 24/7 to help you.',
    ),
    FAQItem(
      question: 'Is my personal information secure?',
      answer:
          'Yes, we take your privacy and security very seriously. All your personal information is encrypted and stored securely. Please read our Privacy Policy for more details about how we protect your data.',
    ),
    FAQItem(
      question: 'Can I use the app offline?',
      answer:
          'Some features of the app require an internet connection. However, you can view your profile and previously loaded information offline. We recommend keeping your app connected to the internet for the best experience.',
    ),
    FAQItem(
      question: 'How often are new deals and promotions added?',
      answer:
          'New deals and promotions are added regularly to keep the app fresh and exciting. Check back often or enable notifications to be notified about the latest offers and special promotions.',
    ),
  ];

  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.redDark,
        centerTitle: true,
        title: const Text(
          'Frequently Asked Questions',
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
                    Icons.lightbulb_outline,
                    size: 28,
                    color: AppColors.greenDark,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Find answers to common questions about the Azzura Rewards program.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.greenDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                final isExpanded = expandedIndex == index;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.greenLight.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.help_outline,
                                    size: 20,
                                    color: AppColors.greenDark,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    faq.question,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.redDark,
                                    ),
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
                            if (isExpanded) ...[

                              const SizedBox(height: 12),

                              Container(
                                height: 1,
                                color: AppColors.grayLight.withOpacity(0.3),
                              ),

                              const SizedBox(height: 12),
                              
                              Text(
                                faq.answer,
                                style: TextStyle(
                                  fontSize: 14,
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
              padding: const EdgeInsets.all(16),
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
                        Icons.chat_bubble_outline,
                        size: 24,
                        color: AppColors.red,
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'Still have questions?',
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
                    'Contact our support team through Live Chat or email us for assistance. We\'re here to help!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grayDark,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
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
                          icon: const Icon(Icons.chat),
                          label: const Text('Live Chat'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.red,
                            side: const BorderSide(color: AppColors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.mail_outline),
                          label: const Text('Contact Us'),
                        ),
                      ),
                    ],
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

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
