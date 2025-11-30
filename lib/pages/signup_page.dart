import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';

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
      extendBodyBehindAppBar: true,
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
          child: Stack(
            children: [
              Container(
                height: size.height * 0.40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
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
                          onPressed: () {},
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
            style: const TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.greenDark),
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