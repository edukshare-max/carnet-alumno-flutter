// API Service for UAGro student app (READ ONLY)
// Handles communication with the backend for carnet and citas data

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Read API base URL from environment variable
  static const String _apiBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://fastapi-backend-o7ks.onrender.com',
  );

  static const Duration _timeout = Duration(seconds: 30);

  // Headers for all requests
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Fetch carnet data by matricula with double attempt (ID and fallback)
  /// Returns carnet data map or null if not found
  static Future<Map<String, dynamic>?> fetchCarnetByMatricula(String matricula) async {
    try {
      // Log the attempt
      print('Attempting to fetch carnet for matricula: $matricula');

      // First attempt: GET /carnet/carnet:{matricula}
      final firstUrl = '$_apiBase/carnet/carnet:$matricula';
      print('First attempt URL: $firstUrl');

      try {
        final firstResponse = await http
            .get(Uri.parse(firstUrl), headers: _headers)
            .timeout(_timeout);

        print('First attempt status: ${firstResponse.statusCode}');

        if (firstResponse.statusCode == 200) {
          final data = json.decode(firstResponse.body);
          print('First attempt successful');
          return data as Map<String, dynamic>;
        }
      } catch (e) {
        print('First attempt failed: $e');
      }

      // Fallback attempt: GET /carnet/{matricula}
      final fallbackUrl = '$_apiBase/carnet/$matricula';
      print('Fallback attempt URL: $fallbackUrl');

      try {
        final fallbackResponse = await http
            .get(Uri.parse(fallbackUrl), headers: _headers)
            .timeout(_timeout);

        print('Fallback attempt status: ${fallbackResponse.statusCode}');

        if (fallbackResponse.statusCode == 200) {
          final data = json.decode(fallbackResponse.body);
          print('Fallback attempt successful');
          return data as Map<String, dynamic>;
        }
      } catch (e) {
        print('Fallback attempt failed: $e');
      }

      print('Both attempts failed for matricula: $matricula');
      return null;
    } catch (e) {
      print('Error fetching carnet for matricula $matricula: $e');
      return null;
    }
  }

  /// Fetch citas (appointments) by matricula
  /// Returns list of citas or empty list if error/not found
  static Future<List<Map<String, dynamic>>> fetchCitas(String matricula) async {
    try {
      print('Fetching citas for matricula: $matricula');

      final url = '$_apiBase/citas/por-matricula/$matricula';
      print('Citas URL: $url');

      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(_timeout);

      print('Citas response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print('Found ${data.length} citas');
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map && data.containsKey('citas')) {
          final citasList = data['citas'] as List;
          print('Found ${citasList.length} citas in wrapper');
          return citasList.cast<Map<String, dynamic>>();
        } else {
          print('Unexpected citas response format');
          return [];
        }
      } else if (response.statusCode == 404) {
        print('No citas found for matricula: $matricula');
        return [];
      } else {
        print('Error fetching citas: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching citas for matricula $matricula: $e');
      return [];
    }
  }

  /// Validate if the provided email matches the carnet email (case-insensitive)
  static bool validateEmailMatch(String providedEmail, String carnetEmail) {
    final normalizedProvided = providedEmail.trim().toLowerCase();
    final normalizedCarnet = carnetEmail.trim().toLowerCase();
    return normalizedProvided == normalizedCarnet;
  }

  /// Check API connectivity
  static Future<bool> checkConnectivity() async {
    try {
      final url = '$_apiBase/health'; // Assuming there's a health check endpoint
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