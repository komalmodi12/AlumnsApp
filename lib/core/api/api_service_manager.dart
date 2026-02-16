import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:alumns_app/core/api/api_config.dart';
import 'package:alumns_app/services/authentication_service.dart';
import 'package:alumns_app/services/pageview_service.dart';
import 'package:alumns_app/services/user_service.dart';

/// API Service Manager
///
/// Central service for managing all API interactions
/// Handles initialization and provides access to all services
///
/// Usage:
/// ```dart
/// final apiManager = ApiServiceManager(useQa: true);
/// await apiManager.initialize();
///
/// // Use services
/// await apiManager.auth.login(email: 'user@example.com', password: 'pass');
/// await apiManager.pageView.trackPageView(pageName: 'home');
/// ```
class ApiServiceManager {
  late final Dio _dio;
  late final FlutterSecureStorage _storage;
  late final String _baseUrl;

  late final AuthenticationService auth;
  late final PageViewService pageView;
  late final UserService user;

  ApiServiceManager({bool useQa = true}) {
    _baseUrl = ApiConfig.getBaseUrl(useQa: useQa);
    _storage = const FlutterSecureStorage();
    _initializeDio();
    _initializeServices();
  }

  /// Initialize Dio with interceptors
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Add request interceptor for JWT token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'jwt_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          developer.log(
            '${options.method} ${options.path}',
            name: 'ApiServiceManager.Request',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log(
            'Success: ${response.statusCode} ${response.requestOptions.path}',
            name: 'ApiServiceManager.Response',
          );
          return handler.next(response);
        },
        onError: (error, handler) async {
          developer.log(
            'Error: ${error.response?.statusCode} - ${error.message}',
            level: 900,
            name: 'ApiServiceManager.Error',
          );

          // Handle 401 Unauthorized - clear token
          if (error.response?.statusCode == 401) {
            await _storage.delete(key: 'jwt_token');
            await _storage.delete(key: 'refresh_token');
          }

          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => developer.log(obj.toString(), name: 'DioLog'),
      ),
    );
  }

  /// Initialize all services
  void _initializeServices() {
    auth = AuthenticationService(
      dio: _dio,
      storage: _storage,
      baseUrl: _baseUrl,
    );

    pageView = PageViewService(dio: _dio, baseUrl: _baseUrl);

    user = UserService(dio: _dio, baseUrl: _baseUrl);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }

  /// Get stored JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  /// Clear all application data
  Future<void> clearAllData() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'refresh_token');
  }

  /// Get Dio instance for custom requests
  Dio getDio() => _dio;

  /// Get storage instance for custom storage operations
  FlutterSecureStorage getStorage() => _storage;

  /// Get base URL
  String getBaseUrl() => _baseUrl;
}

// Global API Service Manager instance
class ApiService {
  static final ApiService _instance = ApiService._internal();
  static late ApiServiceManager _manager;

  ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  /// Initialize API Service
  static void initialize({bool useQa = true}) {
    _manager = ApiServiceManager(useQa: useQa);
  }

  /// Get API Service Manager
  static ApiServiceManager get manager => _manager;

  /// Quick access to auth service
  static AuthenticationService get auth => _manager.auth;

  /// Quick access to pageview service
  static PageViewService get pageView => _manager.pageView;

  /// Quick access to user service
  static UserService get user => _manager.user;
}
