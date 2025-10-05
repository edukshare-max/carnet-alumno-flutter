import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'session.dart';

/// API Service for the UAGro Carnet App
/// Provides read-only access to student carnet and appointment data
class ApiService {
  static const String _defaultBaseUrl = 'https://alumno-backend-node.onrender.com';
  static const String _corsProxyUrl = 'https://cors-anywhere.herokuapp.com/';
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

  /// Get proxied URL for CORS-enabled requests
  String _getProxiedUrl(String endpoint) {
    // For now, try direct connection and let's see if backend has been configured
    final directUrl = '$baseUrl$endpoint';
    if (kDebugMode) {
      print('Using direct URL: $directUrl');
    }
    return directUrl;
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
      final url = _getProxiedUrl('/auth/login');
      final body = json.encode({
        'email': email.trim().toLowerCase(),
        'matricula': matricula.trim(),
      });

      if (kDebugMode) {
        print('🚀 LOGIN START - URL: $url');
        print('📤 PAYLOAD: $body');
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      ).timeout(timeoutDuration);

      if (kDebugMode) {
        print('📡 RESPONSE STATUS: ${response.statusCode}');
        print('📡 RESPONSE HEADERS: ${response.headers}');
        print('📡 RESPONSE BODY RAW: ${response.body}');
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ STATUS 200 - Attempting JSON decode...');
        }
        
        final data = json.decode(response.body);
        
        if (kDebugMode) {
          print('✅ JSON DECODED: $data');
          print('✅ DATA TYPE: ${data.runtimeType}');
        }
        
        // Defensive token extraction - handle multiple response formats
        String? token;
        if (data is Map<String, dynamic>) {
          if (kDebugMode) {
            print('✅ DATA IS MAP - Extracting token...');
          }
          
          // Try each possible token field with null safety
          final rawToken = data['access_token'] ?? 
                          data['accessToken'] ?? 
                          data['token'] ?? 
                          data['jwt'];
          
          if (kDebugMode) {
            print('🔑 RAW TOKEN: ${rawToken?.runtimeType} - ${rawToken != null ? '[EXISTS]' : '[NULL]'}');
          }
          
          // Convert to string only if not null and handle whitespace
          token = rawToken?.toString().trim();
          
          if (kDebugMode) {
            print('🔑 FINAL TOKEN: ${token != null ? '[LENGTH:${token!.length}]' : '[NULL]'}');
          }
        } else {
          if (kDebugMode) {
            print('❌ DATA NOT MAP - Type: ${data.runtimeType}');
          }
        }
        
        if (token?.isNotEmpty == true) {
          if (kDebugMode) {
            print('🎉 TOKEN VALID - Storing and returning...');
          }
          // Store the token for future requests
          _authToken = token!;
          final result = {'token': token};
          if (kDebugMode) {
            print('🎉 RETURNING RESULT: $result');
          }
          return result;
        } else {
          if (kDebugMode) {
            print('❌ TOKEN EMPTY OR NULL - Failing login');
          }
        }
      } else if (response.statusCode == 401) {
        if (kDebugMode) {
          print('❌ STATUS 401 - Invalid credentials from server');
        }
        return null;
      } else {
        if (kDebugMode) {
          print('❌ STATUS ${response.statusCode} - Server error');
        }
        return null;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('💥 EXCEPTION CAUGHT: $e');
        print('💥 STACK TRACE: $stackTrace');
      }
      return null;
    }
    
    if (kDebugMode) {
      print('❌ REACHED END - Returning null');
    }
    return null;
  }

  /// Fetch student carnet data for authenticated user
  Future<Map<String, dynamic>?> fetchCarnetByMatricula(String matricula) async {
    if (_authToken == null) {
      throw ApiException('No estás autenticado');
    }

    try {
      final url = _getProxiedUrl('/me/carnet');
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
      final url = _getProxiedUrl('/me/citas');
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
      final url = _getProxiedUrl('/me/carnet');
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
      final url = _getProxiedUrl('/me/citas');
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