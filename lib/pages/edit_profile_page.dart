// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();

  final List<String> prefixOptions = ['+62', '+60', '+65', '+66', '+32', '+81'];

  String selectedPrefix = '+62';
  Uint8List? avatarBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    addressC.dispose();
    usernameC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    final userProvider = context.read<UserProvider>();

    nameC.text = userProvider.fullName;
    emailC.text = userProvider.email;
    addressC.text = userProvider.address;
    usernameC.text = userProvider.username;
    passwordC.text = userProvider.password;

    String phone = userProvider.phone;
    for (var p in prefixOptions) {
      final noPlus = p.replaceAll('+', '');

      if (phone.startsWith(p)) {
        selectedPrefix = p;
        phoneC.text = phone.substring(p.length);
        break;
      } else if (phone.startsWith(noPlus)) {
        selectedPrefix = p;
        phoneC.text = phone.substring(noPlus.length);
        break;
      }
    }

    if (!prefixOptions.contains(selectedPrefix)) {
      selectedPrefix = prefixOptions.first;
    }

    if (userProvider.avatar.isNotEmpty) {
      try {
        avatarBytes = base64Decode(userProvider.avatar);
      } catch (e) {
        debugPrint('Error decoding avatar: $e');
      }
    }

    setState(() {});
  }

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.first.bytes != null) {
      setState(() {
        avatarBytes = result.files.first.bytes!;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (nameC.text.isEmpty) {
      _showError('Nama tidak boleh kosong');
      return;
    }

    if (emailC.text.isEmpty || !emailC.text.contains('@')) {
      _showError('Email tidak valid');
      return;
    }

    if (phoneC.text.isEmpty) {
      _showError('Nomor telepon tidak boleh kosong');
      return;
    }

    if (usernameC.text.isEmpty) {
      _showError('Username tidak boleh kosong');
      return;
    }

    if (passwordC.text.isEmpty) {
      _showError('Password tidak boleh kosong');
      return;
    }

    if (passwordC.text.length < 6) {
      _showError('Password minimal 6 karakter');
      return;
    }

    setState(() => _isLoading = true);

    final userProvider = context.read<UserProvider>();

    String avatarBase64 = '';
    if (avatarBytes != null) {
      avatarBase64 = base64Encode(avatarBytes!);
    }

    final result = await userProvider.updateProfile(
      fullName: nameC.text.trim(),
      email: emailC.text.trim(),
      phone: "$selectedPrefix${phoneC.text.trim()}",
      address: addressC.text.trim(),
      username: usernameC.text.trim(),
      password: passwordC.text,
      avatar: avatarBase64,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(result['message']),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      _showError(result['message']);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.redDark,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const BackButton(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickAvatar,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.redLight.withOpacity(0.2),
                        backgroundImage: avatarBytes != null
                            ? MemoryImage(avatarBytes!)
                            : null,
                        child: avatarBytes == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.redDark,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.redDark,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameC,
                        decoration: _inputDecoration(
                          "Full Name",
                          Icons.person_outline,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailC,
                        decoration: _inputDecoration(
                          "Email",
                          Icons.email_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.redDark.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: selectedPrefix,
                        underline: const SizedBox(),
                        items: prefixOptions.map((prefix) {
                          return DropdownMenuItem(
                            value: prefix,
                            child: Text(
                              prefix,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => selectedPrefix = v);
                          }
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: phoneC,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                          "Phone Number",
                          Icons.phone_outlined,
                        ).copyWith(prefixText: "$selectedPrefix "),
                        onChanged: (value) {
                          for (var p in prefixOptions) {
                            if (value.startsWith(p)) {
                              final clean = value.replaceFirst(p, "").trim();
                              phoneC.value = TextEditingValue(
                                text: clean,
                                selection: TextSelection.collapsed(
                                  offset: clean.length,
                                ),
                              );
                              break;
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: addressC,
                  decoration: _inputDecoration(
                    "Address",
                    Icons.location_on_outlined,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: usernameC,
                  decoration: _inputDecoration(
                    "Username",
                    Icons.person_pin_outlined,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordC,
                  obscureText: true,
                  decoration: _inputDecoration("Password", Icons.lock_outline),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.redDark),
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: AppColors.white.withOpacity(0.9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.redDark.withOpacity(0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.redDark, width: 2),
      ),
    );
  }
}