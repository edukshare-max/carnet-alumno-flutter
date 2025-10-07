// API Service for UAGro student app (AUTH-BASED)
// Uses JWT authentication flow: POST /auth/login -> GET /me/carnet + /me/citas

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Read API base URL from environment variable
  static const String _apiBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://alumno-backend-node.onrender.com',
  );

  static const Duration _timeout = Duration(seconds: 30);

  // Current JWT token
  static String? _accessToken;

  // Headers for requests without auth
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Headers for authenticated requests
  static Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      };

  /// Authenticate user with email and matricula
  /// Returns true if login successful, false otherwise
  static Future<bool> login(String email, String matricula) async {
    try {
      print('🔐 Attempting login with email: $email, matricula: $matricula');

      final url = '$_apiBase/auth/login';
      final body = json.encode({
        'email': email.trim().toLowerCase(),
        'matricula': matricula.trim(),
      });

      print('Login URL: $url');
      print('Login body: $body');

      final response = await http
          .post(Uri.parse(url), headers: _headers, body: body)
          .timeout(_timeout);

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['access_token'] != null) {
          _accessToken = data['access_token'];
          print('✅ Login successful, token received');
          return true;
        } else {
          print('❌ Login response missing access_token');
          return false;
        }
      } else {
        print('❌ Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Login error: $e');
      return false;
    }
  }

  /// Fetch carnet data for authenticated user
  /// Returns carnet data map or null if not found
  static Future<Map<String, dynamic>?> fetchCarnet() async {
    if (_accessToken == null) {
      print('❌ No access token available. Please login first.');
      return null;
    }

    try {
      print('📋 Fetching carnet data...');

      final url = '$_apiBase/me/carnet';
      print('Carnet URL: $url');

      final response = await http
          .get(Uri.parse(url), headers: _authHeaders)
          .timeout(_timeout);

      print('Carnet response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Carnet data received');
        return data as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - token may be expired');
        _accessToken = null; // Clear invalid token
        return null;
      } else {
        print('❌ Error fetching carnet: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching carnet: $e');
      return null;
    }
  }

  /// Fetch citas (appointments) for authenticated user
  /// Returns list of citas or empty list if error/not found
  static Future<List<Map<String, dynamic>>> fetchCitas() async {
    if (_accessToken == null) {
      print('❌ No access token available. Please login first.');
      return [];
    }

    try {
      print('📅 Fetching citas data...');

      final url = '$_apiBase/me/citas';
      print('Citas URL: $url');

      final response = await http
          .get(Uri.parse(url), headers: _authHeaders)
          .timeout(_timeout);

      print('Citas response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print('✅ Found ${data.length} citas');
          return data.cast<Map<String, dynamic>>();
        } else {
          print('⚠️ Unexpected citas response format');
          return [];
        }
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - token may be expired');
        _accessToken = null; // Clear invalid token
        return [];
      } else {
        print('❌ Error fetching citas: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching citas: $e');
      return [];
    }
  }

  /// Login and fetch all user data (carnet + citas)
  /// Combined method for convenience
  static Future<Map<String, dynamic>?> loginAndFetchData(String email, String matricula) async {
    try {
      // Step 1: Login
      final loginSuccess = await login(email, matricula);
      if (!loginSuccess) {
        return null;
      }

      // Step 2: Fetch carnet data
      final carnetData = await fetchCarnet();
      if (carnetData == null) {
        return null;
      }

      // Step 3: Fetch citas data
      final citasData = await fetchCitas();

      // Return combined data
      return {
        'carnet': carnetData,
        'citas': citasData,
      };
    } catch (e) {
      print('❌ Error in loginAndFetchData: $e');
      return null;
    }
  }

  /// Check if user is currently authenticated
  static bool get isAuthenticated => _accessToken != null;

  /// Logout (clear token)
  static void logout() {
    _accessToken = null;
    print('🔓 User logged out');
  }

  /// Check API connectivity
  static Future<bool> checkConnectivity() async {
    try {
      final url = '$_apiBase/_health';
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Connectivity check failed: $e');
      return false;
    }
  }

  /// Get API base URL (for debugging purposes)
  static String get apiBaseUrl => _apiBase;
}