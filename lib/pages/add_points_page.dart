import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:azzura_rewards/constants/colors.dart';

class AddPointsPage extends StatefulWidget {
  const AddPointsPage({Key? key}) : super(key: key);

  @override
  State<AddPointsPage> createState() => _AddPointsPageState();
}

class _AddPointsPageState extends State<AddPointsPage> 
    with SingleTickerProviderStateMixin {
  
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _transactionType = 'dine-in';
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05), 
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  int _calculatePoints(String amount) {
    String cleanAmount = amount.replaceAll(RegExp(r'\D'), '');
    if (cleanAmount.isEmpty) return 0;
    int nominal = int.parse(cleanAmount);
    return (nominal / 10000).floor();
  }

  String _formatRupiah(String value) {
    if (value.isEmpty) return '';
    String cleanValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanValue.isEmpty) return '';
    int number = int.parse(cleanValue);
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _handleSubmission() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    String phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    String amountStr = _amountController.text.replaceAll(RegExp(r'\D'), '');
    int amount = amountStr.isEmpty ? 0 : int.parse(amountStr);

    if (phone.isEmpty) {
      _showCustomErrorSnackBar('Phone number is required!');
      return;
    }
    if (phone.length < 10 || phone.length > 13) {
      _showCustomErrorSnackBar('Invalid phone number length (10-13 digits).');
      return;
    }
    if (!phone.startsWith('08') && !phone.startsWith('628')) {
      _showCustomErrorSnackBar('Phone must start with 08 or 628.');
      return;
    }

    if (amountStr.isEmpty) {
      _showCustomErrorSnackBar('Please enter transaction amount.');
      return;
    }
    if (amount < 10000) {
      _showCustomErrorSnackBar('Minimum transaction is Rp 10.000.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      int points = _calculatePoints(_amountController.text);
      
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog(points);
        _resetForm();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showCustomErrorSnackBar('System error. Please try again.');
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _phoneController.clear();
    _amountController.clear();
    setState(() => _transactionType = 'dine-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                _buildHeaderCard(),
                _buildInfoSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildSectionHeader('Customer Information', Icons.person_outline),
                        _buildPhoneInput(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Transaction Details', Icons.payments_outlined),
                        _buildAmountInput(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Service Type', Icons.room_service_outlined),
                        _buildExpandedTransactionTypeSelector(),
                        const SizedBox(height: 32),
                        _buildPointsSummaryCard(),
                        const SizedBox(height: 32),
                        _buildSubmitButton(),
                        const SizedBox(height: 40),
                        _buildRecentHistorySection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'ADD POINTS',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          letterSpacing: 1.5,
          color: AppColors.black,
        ),
      ),
      backgroundColor: AppColors.cream,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.red, AppColors.redDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.stars, color: AppColors.gold, size: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold.withOpacity(0.5)),
                ),
                child: const Text(
                  'LOYALTY PROGRAM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Notti Loyalty',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 26,
              fontFamily: 'Serif', 
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Process transactions to reward loyal customers.',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.85),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conversion Rate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Rp 10.000 = 1 Point',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.gray,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.red),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(13),
        ],
        decoration: const InputDecoration(
          hintText: '08XX-XXXX-XXXX',
          hintStyle: TextStyle(color: AppColors.gray),
          prefixIcon: Icon(Icons.phone_iphone, color: AppColors.grayDark),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          String formatted = _formatRupiah(value);
          if (formatted != value) {
            _amountController.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: '0',
          prefixText: 'Rp ',
          prefixStyle: const TextStyle(
            color: AppColors.grayDark, 
            fontWeight: FontWeight.w500,
            fontSize: 18
          ),
          prefixIcon: const Icon(Icons.monetization_on_outlined, color: AppColors.grayDark),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: _amountController.text.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.grayDark),
                onPressed: () {
                  _amountController.clear();
                  setState(() {});
                },
              )
            : null,
        ),
      ),
    );
  }

  Widget _buildExpandedTransactionTypeSelector() {
    return Column(
      children: [
        _buildDetailedTypeOption(
          title: 'Dine-in', 
          desc: 'Customer eating at restaurant', 
          emoji: '🍽️', 
          value: 'dine-in'
        ),
        const SizedBox(height: 12),
        _buildDetailedTypeOption(
          title: 'Takeaway', 
          desc: 'Order for pick up', 
          emoji: '🥡', 
          value: 'takeaway'
        ),
        const SizedBox(height: 12),
        _buildDetailedTypeOption(
          title: 'Delivery', 
          desc: 'Sent to customer location', 
          emoji: '🚗', 
          value: 'delivery'
        ),
      ],
    );
  }

  Widget _buildDetailedTypeOption({
    required String title, 
    required String desc, 
    required String emoji, 
    required String value
  }) {
    bool isSelected = _transactionType == value;
    
    return GestureDetector(
      onTap: () => setState(() => _transactionType = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.gold : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.gold.withOpacity(0.15) : AppColors.grayLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.black : AppColors.grayDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.gold, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsSummaryCard() {
    String cleanAmount = _amountController.text.replaceAll(RegExp(r'\D'), '');
    int nominal = cleanAmount.isEmpty ? 0 : int.parse(cleanAmount);

    if (_amountController.text.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grayLight.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grayLight.withOpacity(0.5)),
        ),
        child: const Center(
          child: Text(
            'Enter amount to see points calculation',
            style: TextStyle(color: AppColors.gray),
          ),
        ),
      );
    }

    if (nominal < 10000) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: Row(
          children: [
             Container(
               padding: const EdgeInsets.all(10),
               decoration: BoxDecoration(
                 color: AppColors.error.withOpacity(0.15),
                 shape: BoxShape.circle,
               ),
               child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text(
                     "Minimum Transaction",
                     style: TextStyle(
                       color: AppColors.error,
                       fontWeight: FontWeight.bold,
                       fontSize: 14,
                     ),
                   ),
                   const SizedBox(height: 4),
                   Text(
                     "Amount must be at least Rp 10.000 to earn points.",
                     style: TextStyle(
                       color: AppColors.error.withOpacity(0.8),
                       fontSize: 12,
                     ),
                   ),
                 ],
               ),
             ),
          ],
        ),
      );
    }

    int points = _calculatePoints(_amountController.text);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'TOTAL POINTS TO ADD',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '+$points',
            style: const TextStyle(
              color: AppColors.red,
              fontSize: 48,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'For Transaction Rp ${_formatRupiah(_amountController.text)}',
            style: const TextStyle(
              color: AppColors.grayDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmission,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 10,
          shadowColor: AppColors.gold.withOpacity(0.3),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 3),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt_rounded),
                  SizedBox(width: 10),
                  Text(
                    'PROCESS TRANSACTION',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRecentHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              Icon(Icons.history, color: AppColors.gray, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _buildHistoryCard('Dine-in', '120 Pts', 'Just now', true),
              const SizedBox(width: 12),
              _buildHistoryCard('Takeaway', '55 Pts', '2m ago', false),
              const SizedBox(width: 12),
              _buildHistoryCard('Delivery', '200 Pts', '15m ago', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(String type, String points, String time, bool isNew) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: isNew ? Border.all(color: AppColors.success.withOpacity(0.5)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                type == 'Dine-in' ? Icons.restaurant : type == 'Takeaway' ? Icons.takeout_dining : Icons.local_shipping,
                size: 16,
                color: AppColors.grayDark,
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 10, color: AppColors.grayDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            points,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            type,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.priority_high_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Validation Error',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
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

  Future<void> _showSuccessDialog(int points) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: AppColors.success, size: 48),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Transaction Success!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.grayDark, height: 1.5),
                    children: [
                      const TextSpan(text: 'You have successfully added '),
                      TextSpan(
                        text: '$points Points',
                        style: const TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' to the customer account.'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('CLOSE'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}