import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({super.key});

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 24),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.redDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String content) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grayLight.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.redDark.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.greenDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.greenDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletCard(List<String> points) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grayLight.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.redDark.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: points.map((point) => _buildBulletPoint(point)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.redDark,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Terms of Use",
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.redLight.withOpacity(0.2),
                        AppColors.red.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.description,
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last Updated",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grayDark,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "November 28, 2025",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.redDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            _buildSectionTitle("1. Acceptance of Terms"),
            _buildContentCard(
              "By accessing and using the Azzura Rewards application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service."
            ),

            _buildSectionTitle("2. Use License"),
            _buildContentCard(
              "Permission is granted to temporarily download one copy of Azzura Rewards app for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title."
            ),
            _buildBulletCard([
              "Modify or copy the app materials",
              "Use the materials for any commercial purpose",
              "Attempt to decompile or reverse engineer any software",
              "Remove any copyright or proprietary notations",
              "Transfer the materials to another person",
            ]),

            _buildSectionTitle("3. User Account"),
            _buildContentCard(
              "When you create an account with us, you must provide information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms."
            ),
            _buildBulletCard([
              "You are responsible for safeguarding your password",
              "You must notify us immediately of any breach of security",
              "You may not use another user's account",
              "One person may not maintain more than one account",
            ]),

            _buildSectionTitle("4. Rewards Program"),
            _buildContentCard(
              "The Azzura Rewards program allows you to earn points through purchases and activities. Points can be redeemed for rewards as specified in the app."
            ),
            _buildBulletCard([
              "Points have no cash value and cannot be transferred",
              "Points may expire after a period of inactivity",
              "We reserve the right to modify the rewards program",
              "Fraudulent activity will result in account termination",
              "Rewards are subject to availability",
            ]),

            _buildSectionTitle("5. Prohibited Uses"),
            _buildContentCard(
              "You may use our service only for lawful purposes and in accordance with these Terms. You agree not to use the service:"
            ),
            _buildBulletCard([
              "In any way that violates any applicable law or regulation",
              "To exploit, harm, or attempt to exploit or harm minors",
              "To transmit any advertising or promotional material",
              "To impersonate or attempt to impersonate the Company",
              "To engage in any other conduct that restricts or inhibits use",
            ]),

            _buildSectionTitle("6. Intellectual Property"),
            _buildContentCard(
              "The service and its original content, features, and functionality are and will remain the exclusive property of Azzura Rewards and its licensors. The service is protected by copyright, trademark, and other laws."
            ),

            _buildSectionTitle("7. User Content"),
            _buildContentCard(
              "Our service may allow you to post, link, store, share and otherwise make available certain information, text, graphics, or other material. You are responsible for the content you post."
            ),
            _buildBulletCard([
              "You retain all rights to your content",
              "You grant us a license to use, modify, and display your content",
              "We may remove content that violates these terms",
              "You represent that you own or control all rights to content",
            ]),

            _buildSectionTitle("8. Termination"),
            _buildContentCard(
              "We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms."
            ),

            _buildSectionTitle("9. Limitation of Liability"),
            _buildContentCard(
              "In no event shall Azzura Rewards, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses."
            ),

            _buildSectionTitle("10. Disclaimer"),
            _buildContentCard(
              "Your use of the service is at your sole risk. The service is provided on an \"AS IS\" and \"AS AVAILABLE\" basis. The service is provided without warranties of any kind, whether express or implied."
            ),

            _buildSectionTitle("11. Changes to Terms"),
            _buildContentCard(
              "We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days notice prior to any new terms taking effect."
            ),

            _buildSectionTitle("12. Contact Information"),
            _buildContentCard(
              "If you have any questions about these Terms, please contact us at support@azzurarewards.com or call us at +62 21 1234 5678."
            ),

            const SizedBox(height: 32),

            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Container(
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.greenDark,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "By continuing to use Azzura Rewards, you acknowledge that you have read and understood these Terms of Use.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greenDark,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}