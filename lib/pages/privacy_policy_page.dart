import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> with TickerProviderStateMixin {
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

  Widget _buildHighlightCard(String title, String content, IconData icon) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.greenDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.greenDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          "Privacy Policy",
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
                          Icons.privacy_tip,
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
                              "Your Privacy Matters",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.redDark,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Last updated: November 28, 2025",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grayDark,
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

            _buildSectionTitle("Introduction"),
            _buildContentCard(
              "At Azzura Rewards, we take your privacy seriously. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. Please read this privacy policy carefully."
            ),

            _buildSectionTitle("Information We Collect"),
            _buildContentCard(
              "We collect information that you provide directly to us when you register for an account, make a purchase, or communicate with us. This may include:"
            ),
            _buildBulletCard([
              "Personal Information: Name, email address, phone number, date of birth",
              "Account Credentials: Username, password, and security questions",
              "Payment Information: Credit card numbers, billing address",
              "Profile Information: Profile picture, preferences, and settings",
              "Communication Data: Messages, feedback, and support requests",
            ]),

            _buildHighlightCard(
              "Automatic Information",
              "We automatically collect certain information when you use our app, including device information, IP address, browser type, operating system, and usage data.",
              Icons.phonelink_setup,
            ),

            _buildSectionTitle("How We Use Your Information"),
            _buildContentCard(
              "We use the information we collect for various purposes, including:"
            ),
            _buildBulletCard([
              "To provide, maintain, and improve our services",
              "To process your transactions and manage your rewards",
              "To send you notifications about your account and orders",
              "To respond to your comments, questions, and requests",
              "To personalize your experience and recommend products",
              "To detect, prevent, and address technical issues or fraud",
              "To send you marketing communications (with your consent)",
            ]),

            _buildSectionTitle("Information Sharing"),
            _buildContentCard(
              "We do not sell, trade, or rent your personal information to third parties. We may share your information in the following circumstances:"
            ),
            _buildBulletCard([
              "Service Providers: With third-party vendors who perform services on our behalf",
              "Business Transfers: In connection with a merger, sale, or acquisition",
              "Legal Requirements: When required by law or to protect our rights",
              "With Your Consent: When you explicitly agree to share your information",
            ]),

            _buildHighlightCard(
              "Data Security",
              "We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure.",
              Icons.security,
            ),

            _buildSectionTitle("Cookies and Tracking"),
            _buildContentCard(
              "We use cookies and similar tracking technologies to track activity on our app and hold certain information. You can instruct your device to refuse all cookies or to indicate when a cookie is being sent."
            ),

            _buildSectionTitle("Your Privacy Rights"),
            _buildContentCard(
              "Depending on your location, you may have the following rights regarding your personal information:"
            ),
            _buildBulletCard([
              "Access: Request access to your personal information",
              "Correction: Request correction of inaccurate information",
              "Deletion: Request deletion of your personal information",
              "Objection: Object to processing of your information",
              "Portability: Request transfer of your information",
              "Withdraw Consent: Withdraw consent for data processing",
            ]),

            _buildSectionTitle("Children's Privacy"),
            _buildContentCard(
              "Our service is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us."
            ),

            _buildSectionTitle("Third-Party Services"),
            _buildContentCard(
              "Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to read their privacy policies."
            ),

            _buildSectionTitle("Data Retention"),
            _buildContentCard(
              "We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law."
            ),

            _buildHighlightCard(
              "International Data Transfers",
              "Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place for such transfers.",
              Icons.language,
            ),

            _buildSectionTitle("Changes to Privacy Policy"),
            _buildContentCard(
              "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Last Updated' date."
            ),

            _buildSectionTitle("Contact Us"),
            _buildContentCard(
              "If you have any questions about this Privacy Policy, please contact us at:"
            ),
            _buildBulletCard([
              "Email: privacy@azzurarewards.com",
              "Phone: +62 21 1234 5678",
              "Address: Jl. Sudirman No. 123, Jakarta, Indonesia",
            ]),

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
                        AppColors.gold.withOpacity(0.1),
                        AppColors.red.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.gold.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: AppColors.gold,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Your data is encrypted and securely stored. We are committed to protecting your privacy and maintaining the security of your information.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.redDark,
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