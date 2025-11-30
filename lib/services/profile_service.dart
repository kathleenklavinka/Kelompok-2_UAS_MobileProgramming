import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    String? avatarBase64,
    String? address,
    String? username,
    String? password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setString("phone", phone);

    if (avatarBase64 != null && avatarBase64.isNotEmpty) {
      await prefs.setString("avatar", avatarBase64);
    }

    if (address != null) await prefs.setString("address", address);
    if (username != null) await prefs.setString("username", username);
    if (password != null) await prefs.setString("password", password);
  }

  static Future<Map<String, String>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "name": prefs.getString("name") ?? "New User",
      "email": prefs.getString("email") ?? "email@example.com",
      "phone": prefs.getString("phone") ?? "-",
      "avatar": prefs.getString("avatar") ?? "",
      "address": prefs.getString("address") ?? "",
      "username": prefs.getString("username") ?? "",
      "password": prefs.getString("password") ?? "",
    };
  }

  static Future<void> saveAvatar(String base64Str) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("avatar", base64Str);
  }

  static const String _kStreakDaysKey = 'streak_days';
  static const String _kStreakLastKey = 'streak_last';

  static Future<void> saveStreak(int days, String lastCheckInIso) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kStreakDaysKey, days);
    await prefs.setString(_kStreakLastKey, lastCheckInIso);
  }

  static Future<Map<String, dynamic>> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final days = prefs.getInt(_kStreakDaysKey) ?? 0;
    final last = prefs.getString(_kStreakLastKey);
    return {
      "days": days,
      "lastCheckIn": last,
    };
  }

  static Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kStreakDaysKey);
    await prefs.remove(_kStreakLastKey);
  }

  static Future<void> saveBadges(List<String> badges) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("badges", badges);
  }

  static Future<List<String>> loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("badges") ?? [];
  }
}