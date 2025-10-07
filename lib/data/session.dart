// Session management for UAGro student app
// Handles local storage of email and matricula using SharedPreferences

import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const String _keyEmail = 'uagro_student_email';
  static const String _keyMatricula = 'uagro_student_matricula';
  static const String _keyLastLogin = 'uagro_last_login';

  /// Save session data locally
  static Future<bool> save(String email, String matricula) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyMatricula, matricula);
      await prefs.setInt(_keyLastLogin, timestamp);
      
      print('Session saved for email: $email, matricula: $matricula');
      return true;
    } catch (e) {
      print('Error saving session: $e');
      return false;
    }
  }

  /// Get saved email
  static Future<String?> getEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyEmail);
    } catch (e) {
      print('Error getting email from session: $e');
      return null;
    }
  }

  /// Get saved matricula
  static Future<String?> getMatricula() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyMatricula);
    } catch (e) {
      print('Error getting matricula from session: $e');
      return null;
    }
  }

  /// Get last login timestamp
  static Future<DateTime?> getLastLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_keyLastLogin);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      print('Error getting last login from session: $e');
      return null;
    }
  }

  /// Check if user is logged in (has valid session)
  static Future<bool> isLoggedIn() async {
    final email = await getEmail();
    final matricula = await getMatricula();
    return email != null && matricula != null && email.isNotEmpty && matricula.isNotEmpty;
  }

  /// Get complete session data
  static Future<Map<String, String?>> getSessionData() async {
    final email = await getEmail();
    final matricula = await getMatricula();
    final lastLogin = await getLastLogin();
    
    return {
      'email': email,
      'matricula': matricula,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  /// Clear session data (logout)
  static Future<bool> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyMatricula);
      await prefs.remove(_keyLastLogin);
      
      print('Session cleared');
      return true;
    } catch (e) {
      print('Error clearing session: $e');
      return false;
    }
  }

  /// Check if session is expired (older than 30 days)
  static Future<bool> isSessionExpired() async {
    final lastLogin = await getLastLogin();
    if (lastLogin == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastLogin);
    
    // Session expires after 30 days
    return difference.inDays > 30;
  }

  /// Refresh session timestamp
  static Future<bool> refreshSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      await prefs.setInt(_keyLastLogin, timestamp);
      print('Session refreshed');
      return true;
    } catch (e) {
      print('Error refreshing session: $e');
      return false;
    }
  }

  /// Get session info for debugging
  static Future<String> getSessionInfo() async {
    final sessionData = await getSessionData();
    final isValid = await isLoggedIn();
    final isExpired = await isSessionExpired();
    
    return '''
Session Info:
- Email: ${sessionData['email'] ?? 'Not set'}
- Matricula: ${sessionData['matricula'] ?? 'Not set'}
- Last Login: ${sessionData['lastLogin'] ?? 'Never'}
- Is Valid: $isValid
- Is Expired: $isExpired
''';
  }
}