import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  String _userId = '';
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _username = '';
  String _password = '';
  String _avatar = '';
  bool _isLoggedIn = false;

  String get userId => _userId;
  String get fullName => _fullName;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  String get username => _username;
  String get password => _password;
  String get avatar => _avatar;
  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    _userId = prefs.getString('userId') ?? '';
    _fullName = prefs.getString('fullName') ?? '';
    _email = prefs.getString('email') ?? '';
    _phone = prefs.getString('phone') ?? '';
    _address = prefs.getString('address') ?? '';
    _username = prefs.getString('username') ?? '';
    _password = prefs.getString('password') ?? '';
    _avatar = prefs.getString('avatar') ?? '';
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    notifyListeners();
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('userId', _userId);
    await prefs.setString('fullName', _fullName);
    await prefs.setString('email', _email);
    await prefs.setString('phone', _phone);
    await prefs.setString('address', _address);
    await prefs.setString('username', _username);
    await prefs.setString('password', _password);
    await prefs.setString('avatar', _avatar);
    await prefs.setBool('isLoggedIn', _isLoggedIn);
  }

  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      return {'success': false, 'message': 'Semua field harus diisi'};
    }

    if (!email.contains('@')) {
      return {'success': false, 'message': 'Format email tidak valid'};
    }

    if (password.length < 6) {
      return {'success': false, 'message': 'Password minimal 6 karakter'};
    }

    if (password != confirmPassword) {
      return {'success': false, 'message': 'Password tidak cocok'};
    }

    final prefs = await SharedPreferences.getInstance();
    final existingUsers = prefs.getStringList('registered_users') ?? [];

    for (String userJson in existingUsers) {
      final user = json.decode(userJson);
      if (user['email'] == email) {
        return {'success': false, 'message': 'Email sudah terdaftar'};
      }
    }

    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final newUser = {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'address': '',
      'username': email.split('@')[0],
      'avatar': '',
      'createdAt': DateTime.now().toIso8601String(),
    };

    existingUsers.add(json.encode(newUser));
    await prefs.setStringList('registered_users', existingUsers);

    _userId = userId;
    _fullName = fullName;
    _email = email;
    _phone = phone;
    _password = password;
    _address = '';
    _username = email.split('@')[0];
    _avatar = '';
    _isLoggedIn = true;

    await _saveUserData();
    notifyListeners();

    return {'success': true, 'message': 'Akun berhasil dibuat'};
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return {'success': false, 'message': 'Email dan password harus diisi'};
    }

    final prefs = await SharedPreferences.getInstance();
    final existingUsers = prefs.getStringList('registered_users') ?? [];

    for (String userJson in existingUsers) {
      final user = json.decode(userJson);

      if (user['email'] == email && user['password'] == password) {
        _userId = user['userId'];
        _fullName = user['fullName'];
        _email = user['email'];
        _phone = user['phone'];
        _password = user['password'];
        _address = user['address'] ?? '';
        _username = user['username'] ?? email.split('@')[0];
        _avatar = user['avatar'] ?? '';
        _isLoggedIn = true;

        await _saveUserData();
        notifyListeners();

        return {'success': true, 'message': 'Login berhasil'};
      }
    }

    return {'success': false, 'message': 'Email atau password salah'};
  }

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? username,
    String? password,
    String? avatar,
  }) async {
    if (!_isLoggedIn) {
      return {'success': false, 'message': 'User tidak login'};
    }

    if (fullName != null) _fullName = fullName;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (address != null) _address = address;
    if (username != null) _username = username;
    if (password != null) _password = password;
    if (avatar != null) _avatar = avatar;

    await _saveUserData();

    final prefs = await SharedPreferences.getInstance();
    final existingUsers = prefs.getStringList('registered_users') ?? [];
    List<String> updatedUsers = [];

    for (String userJson in existingUsers) {
      final user = json.decode(userJson);

      if (user['userId'] == _userId) {
        user['fullName'] = _fullName;
        user['email'] = _email;
        user['phone'] = _phone;
        user['address'] = _address;
        user['username'] = _username;
        user['password'] = _password;
        user['avatar'] = _avatar;
        user['updatedAt'] = DateTime.now().toIso8601String();
      }

      updatedUsers.add(json.encode(user));
    }

    await prefs.setStringList('registered_users', updatedUsers);
    notifyListeners();

    return {'success': true, 'message': 'Profile berhasil diupdate'};
  }

  Future<void> updateAvatar(String avatarBase64) async {
    _avatar = avatarBase64;
    await updateProfile(avatar: avatarBase64);
  }

  Future<void> logout() async {
    _userId = '';
    _fullName = '';
    _email = '';
    _phone = '';
    _address = '';
    _username = '';
    _password = '';
    _avatar = '';
    _isLoggedIn = false;

    await _saveUserData();
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    await _loadUserData();
    return _isLoggedIn;
  }

  String getDisplayName() {
    if (_fullName.isNotEmpty) return _fullName;
    if (_username.isNotEmpty) return _username;
    if (_email.isNotEmpty) return _email.split('@')[0];
    return 'Guest';
  }

  String getInitials() {
    if (_fullName.isEmpty) return 'U';

    final parts = _fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _fullName[0].toUpperCase();
  }

  Future<void> deleteAccount() async {
    if (!_isLoggedIn) return;

    final prefs = await SharedPreferences.getInstance();
    final existingUsers = prefs.getStringList('registered_users') ?? [];

    existingUsers.removeWhere((userJson) {
      final user = json.decode(userJson);
      return user['userId'] == _userId;
    });

    await prefs.setStringList('registered_users', existingUsers);
    await logout();
  }

  Future<void> refresh() async {
    await _loadUserData();
  }
}