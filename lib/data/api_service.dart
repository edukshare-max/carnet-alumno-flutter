import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'session.dart';

/// API Service for the UAGro Carnet App
/// Provides read-only access to student carnet and appointment data
class ApiService {
  static const String _defaultBaseUrl = 'http://localhost:10000';
  final String baseUrl;
  final Duration timeoutDuration;
  String? _authToken;

  ApiService({
    String? baseUrl,
    this.timeoutDuration = const Duration(seconds: 30),
  }) : baseUrl = baseUrl ?? 
         const String.fromEnvironment('STUDENT_API_BASE_URL', defaultValue: _defaultBaseUrl) {
    // Log URL en modo debug
    if (kDebugMode) {
      print('API Service initialized with base URL: ${this.baseUrl}');
    }
  }

  /// Get base URL (reads from STUDENT_API_BASE_URL environment or uses default)
  String getBase() {
    return const String.fromEnvironment('STUDENT_API_BASE_URL', defaultValue: _defaultBaseUrl);
  }

  /// Set authentication token for API requests
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Default headers for all API requests
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  /// Authenticate user and get JWT token
  Future<Map<String, dynamic>?> login(String email, String matricula) async {
    if (email.trim().isEmpty || matricula.trim().isEmpty) {
      print('Login failed: Email and matricula are required');
      return null;
    }

    try {
      final url = '$baseUrl/auth/login';
      final body = json.encode({
        'email': email.trim().toLowerCase(),
        'matricula': matricula.trim(),
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('access_token')) {
          // Store the token for future requests
          _authToken = data['access_token'];
          return {'token': data['access_token']};
        }
      } else if (response.statusCode == 401) {
        print('Login failed: Invalid credentials');
        return null;
      } else {
        print('Login failed: Server error ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
    
    return null;
  }

  /// Fetch student carnet data for authenticated user
  Future<Map<String, dynamic>?> fetchCarnetByMatricula(String matricula) async {
    if (_authToken == null) {
      throw ApiException('No estás autenticado');
    }

    try {
      final url = '$baseUrl/me/carnet';
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        }
      } else if (response.statusCode == 401) {
        throw ApiException('Sesión expirada');
      } else if (response.statusCode == 404) {
        throw ApiException('Carnet no encontrado');
      } else {
        throw ApiException('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión: ${e.toString()}');
    }
    
    return null;
  }

  /// Fetch appointments for authenticated user
  Future<List<Map<String, dynamic>>> fetchCitas(String matricula) async {
    if (_authToken == null) {
      throw ApiException('No estás autenticado');
    }

    try {
      final url = '$baseUrl/me/citas';
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      } else if (response.statusCode == 401) {
        throw ApiException('Sesión expirada');
      } else {
        throw ApiException('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión: ${e.toString()}');
    }
    
    return [];
  }

  /// Get carnet data using stored token
  Future<Map<String, dynamic>?> getMyCarnet(String token) async {
    try {
      final url = '$baseUrl/me/carnet';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        }
      } else if (response.statusCode == 401) {
        // Session expired - clear token and return null
        await _handleSessionExpired();
        return null;
      }
    } catch (e) {
      print('Error getting carnet: $e');
    }
    
    return null;
  }

  /// Get citas data using stored token
  Future<List<Map<String, dynamic>>> getMyCitas(String token) async {
    try {
      final url = '$baseUrl/me/citas';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      } else if (response.statusCode == 401) {
        // Session expired - clear token and return empty list
        await _handleSessionExpired();
        return [];
      }
    } catch (e) {
      print('Error getting citas: $e');
    }
    
    return [];
  }

  /// Handle session expiration
  Future<void> _handleSessionExpired() async {
    _authToken = null;
    await Session.clearToken();
  }

  /// Clear authentication token
  void logout() {
    _authToken = null;
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => message;
}