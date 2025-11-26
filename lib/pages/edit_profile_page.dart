// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';
import 'package:azzura_rewards/services/profile_service.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

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

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final data = await ProfileService.loadProfile();

    nameC.text = data["name"] ?? "";
    emailC.text = data["email"] ?? "";
    phoneC.text = data["phone"] ?? "";
    addressC.text = data["address"] ?? "";
    usernameC.text = data["username"] ?? "";
    passwordC.text = data["password"] ?? "";

    for (var p in prefixOptions) {
      final noPlus = p.replaceAll('+', '');

      if (phoneC.text.startsWith(p)) {
        selectedPrefix = p;
        phoneC.text = phoneC.text.substring(p.length);
        break;
      } else if (phoneC.text.startsWith(noPlus)) {
        selectedPrefix = p;
        phoneC.text = phoneC.text.substring(noPlus.length);
        break;
      }
    }

    if (!prefixOptions.contains(selectedPrefix)) {
      selectedPrefix = prefixOptions.first;
    }

    if (data["avatar"] != null && data["avatar"]!.isNotEmpty) {
      avatarBytes = base64Decode(data["avatar"]!);
    }

    setState(() {});
  }

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.first.bytes != null) {
      avatarBytes = result.files.first.bytes!;
      final base64Str = base64Encode(avatarBytes!);
      await ProfileService.saveAvatar(base64Str);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.redDark,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
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
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.redLight.withOpacity(0.2),
                    backgroundImage:
                        avatarBytes != null ? MemoryImage(avatarBytes!) : null,
                    child: avatarBytes == null
                        ? const Icon(Icons.person,
                            size: 50, color: AppColors.redDark)
                        : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameC,
                        decoration:
                            _inputDecoration("Full Name", Icons.person_outline),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailC,
                        decoration:
                            _inputDecoration("Email", Icons.email_outlined),
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
                            child: Text(prefix,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                        decoration: _inputDecoration("Phone Number", Icons.phone_outlined)
                            .copyWith(prefixText: "$selectedPrefix "),
                        onChanged: (value) {
                          for (var p in prefixOptions) {
                            if (value.startsWith(p)) {
                              final clean = value.replaceFirst(p, "").trim();
                              phoneC.value = TextEditingValue(
                                text: clean,
                                selection: TextSelection.collapsed(offset: clean.length),
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
                  decoration:
                      _inputDecoration("Address", Icons.location_on_outlined),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: usernameC,
                  decoration: _inputDecoration(
                      "Username", Icons.person_pin_outlined),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordC,
                  obscureText: true,
                  decoration:
                      _inputDecoration("Password", Icons.lock_outline),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ProfileService.saveProfile(
                    name: nameC.text,
                    email: emailC.text,
                    phone: "$selectedPrefix${phoneC.text}",
                    address: addressC.text,
                    username: usernameC.text,
                    password: passwordC.text,
                  );
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: AppColors.redDark.withOpacity(0.3), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.redDark, width: 2),
      ),
    );
  }
}
