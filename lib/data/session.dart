import 'package:shared_preferences/shared_preferences.dart';

/// Session data model
class SessionData {
  final String email;
  final String matricula;
  final String? token;
  final DateTime lastLoginTime;

  SessionData({
    required this.email,
    required this.matricula,
    this.token,
    required this.lastLoginTime,
  });
}

/// Session management for the UAGro Carnet App
/// Handles persistent storage of user authentication data
class Session {
  Session._();

  // Storage keys
  static const String _keyEmail = 'user_email';
  static const String _keyMatricula = 'user_matricula';
  static const String _keyToken = 'auth_token';
  static const String _keyLastLoginTime = 'last_login_time';

  /// Save user session data with token
  static Future<void> saveSessionData({
    required String email,
    required String matricula,
    String? token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_keyEmail, email.toLowerCase().trim());
    await prefs.setString(_keyMatricula, matricula.trim());
    if (token != null) {
      await prefs.setString(_keyToken, token);
    }
    await prefs.setString(_keyLastLoginTime, DateTime.now().toIso8601String());
  }

  /// Get complete session data
  static Future<SessionData?> getSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final email = prefs.getString(_keyEmail);
    final matricula = prefs.getString(_keyMatricula);
    final token = prefs.getString(_keyToken);
    final lastLoginTimeStr = prefs.getString(_keyLastLoginTime);
    
    if (email == null || matricula == null || lastLoginTimeStr == null) {
      return null;
    }
    
    try {
      final lastLoginTime = DateTime.parse(lastLoginTimeStr);
      return SessionData(
        email: email,
        matricula: matricula,
        token: token,
        lastLoginTime: lastLoginTime,
      );
    } catch (e) {
      return null;
    }
  }

  /// Clear all session data
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyMatricula);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyLastLoginTime);
  }

  /// Save user session data (backward compatibility)
  static Future<void> save({
    required String email,
    required String matricula,
  }) async {
    await saveSessionData(email: email, matricula: matricula);
  }

  /// Get saved email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  /// Get saved matricula
  static Future<String?> getMatricula() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMatricula);
  }

  /// Get saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Set token
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  /// Clear token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final sessionData = await getSessionData();
    return sessionData != null;
  }

  /// Get session age in days
  static Future<int?> getSessionAgeDays() async {
    final sessionData = await getSessionData();
    if (sessionData == null) return null;
    
    final now = DateTime.now();
    final difference = now.difference(sessionData.lastLoginTime);
    return difference.inDays;
  }

  /// Check if session needs revalidation (older than specified days)
  static Future<bool> needsRevalidation({int maxDays = 7}) async {
    final sessionAge = await getSessionAgeDays();
    if (sessionAge == null) return true;
    
    return sessionAge > maxDays;
  }
}