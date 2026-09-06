import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/models.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  static const String _baseUrl = 'http://localhost:8000';
  // In production, use: 'https://yourdomain.com'
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'FarmAlert/1.0.0',
        },
      ),
    );

    // Add interceptors for logging and token management
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = await _secureStorage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('📤 Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          print('❌ Error: ${error.response?.statusCode} ${error.message}');
          
          // Handle token refresh on 401
          if (error.response?.statusCode == 401) {
            await _refreshToken();
          }
          
          return handler.next(error);
        },
      ),
    );
  }

  // ==================== AUTHENTICATION ====================

  /// Register new user
  Future<User> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login user
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save tokens securely
      await _secureStorage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );
      await _secureStorage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );
      
      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Refresh access token
  Future<AuthResponse> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      
      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      final response = await _dio.post(
        '/auth/refresh',
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
        ),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Update tokens
      await _secureStorage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );
      await _secureStorage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  // ==================== USER ENDPOINTS ====================

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Change password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _dio.put(
        '/users/me/password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== FARMER ENDPOINTS ====================

  /// Create/update farmer profile
  Future<void> updateFarmerProfile(FarmerProfileRequest request) async {
    try {
      await _dio.post(
        '/farmers/profile',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Submit pest report
  Future<PestReport> submitPestReport(PestReportRequest request) async {
    try {
      final response = await _dio.post(
        '/farmers/pests',
        data: request.toJson(),
      );
      return PestReport.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get pest reports for farmer
  Future<List<PestReport>> getPestReports() async {
    try {
      final response = await _dio.get('/farmers/pests');
      final list = response.data as List;
      return list.map((e) => PestReport.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== CROP PRICES ====================

  /// Get crop prices
  Future<List<CropPrice>> getCropPrices({String location = 'Kampala'}) async {
    try {
      final response = await _dio.get(
        '/api/prices',
        queryParameters: {'location': location},
      );
      final list = response.data as List;
      return list.map((e) => CropPrice.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== HEALTH CHECK ====================

  /// Check API health
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ==================== PRIVATE METHODS ====================

  Future<void> _refreshToken() async {
    try {
      await refreshToken();
    } catch (e) {
      await logout();
      rethrow;
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
        return data['detail'] as String;
      }
      return 'Error: ${error.response?.statusCode}';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Server timeout. Please try again.';
    } else {
      return 'Network error: ${error.message}';
    }
  }

  /// Set base URL (for changing API endpoint)
  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  /// Get auth status
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token != null;
  }

  /// Get stored tokens
  Future<Map<String, String?>> getTokens() async {
    return {
      'access_token': await _secureStorage.read(key: 'access_token'),
      'refresh_token': await _secureStorage.read(key: 'refresh_token'),
    };
  }
}
