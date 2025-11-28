import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette Copy
  static const Color red = Color(0xFF821F06);
  static const Color green = Color(0xFF7D8D36); // Green for Signup Accent
  static const Color greenDark = Color(0xFF5C6925);
  static const Color cream = Color(0xFFF5ECDD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gold = Color(0xFFC4A46A);
  static const Color gray = Color(0xFF8A837A);
  static const Color textDark = Color(0xFF2D2D2D);
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscurePass = true;
  bool _isObscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.cream,
      extendBodyBehindAppBar: true, // Agar AppBar transparan di atas background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          // Gunakan constraint minHeight agar pas di layar panjang, tapi bisa scroll jika overflow
          child: Stack(
            children: [
              // 1. BACKGROUND HEADER (Green Theme for Fresh Start)
              Container(
                height: size.height * 0.40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    // Menggunakan Hijau sesuai palet Anda, atau bisa tetap Merah jika ingin konsisten
                    colors: [AppColors.greenDark, AppColors.green], 
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
              ),

              // 2. HEADER TEXT
              Positioned(
                top: size.height * 0.12,
                left: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Join Us,",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 32,
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Start earning rewards today.",
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. FLOATING FORM
              Container(
                margin: EdgeInsets.only(top: size.height * 0.28, left: 24, right: 24, bottom: 30),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greenDark.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildLuxuryTextField(
                        label: "Full Name",
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildLuxuryTextField(
                        label: "Phone Number",
                        icon: Icons.phone_iphone,
                        inputType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildLuxuryTextField(
                        label: "Email Address",
                        icon: Icons.email_outlined,
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildLuxuryTextField(
                        label: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isObscure: _isObscurePass,
                        onToggle: () => setState(() => _isObscurePass = !_isObscurePass),
                      ),
                      const SizedBox(height: 16),
                      _buildLuxuryTextField(
                        label: "Confirm Password",
                        icon: Icons.verified_user_outlined,
                        isPassword: true,
                        isObscure: _isObscureConfirm,
                        onToggle: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                      ),
                      const SizedBox(height: 32),
                      
                      // SIGNUP BUTTON
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.green, AppColors.greenDark],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greenDark.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Signup Action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLuxuryTextField({
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.gray,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cream.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray.withOpacity(0.2)),
          ),
          child: TextFormField(
            obscureText: isPassword ? isObscure : false,
            keyboardType: inputType,
            style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.greenDark), // Green icon for signup
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.gray,
                        size: 20,
                      ),
                      onPressed: onToggle,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}