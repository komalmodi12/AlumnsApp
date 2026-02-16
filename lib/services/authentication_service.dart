import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:alumns_app/features/auth/models/api_models.dart';

/// Top-level parsing function for isolates
AuthResponse parseAuthResponseIsolate(Map<String, dynamic> json) {
  return AuthResponse.fromJson(json);
}

class AuthenticationService {
  final Dio dio;
  final FlutterSecureStorage storage;
  final String baseUrl;

  AuthenticationService({
    required this.dio,
    required this.storage,
    required this.baseUrl,
  });

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      developer.log(
        'Login API raw response: ${response.data}',
        name: 'AuthenticationService',
      );

      var data = response.data['data'];

      // handle Map/List responses
      Map<String, dynamic> parsedData;
      if (data is Map<String, dynamic>) {
        parsedData = data;
      } else if (data is List &&
          data.isNotEmpty &&
          data[0] is Map<String, dynamic>) {
        parsedData = data[0];
      } else {
        throw ApiError(
          message: 'Unexpected response format',
          statusCode: response.statusCode,
          code: 'LOGIN_ERROR',
          originalError: null,
        );
      }

      // offload parsing to isolate
      final authResponse = await compute(parseAuthResponseIsolate, parsedData);

      // store tokens securely
      await storage.write(key: 'jwt_token', value: authResponse.token);
      if (authResponse.refreshToken != null) {
        await storage.write(
          key: 'refresh_token',
          value: authResponse.refreshToken!,
        );
      }

      return authResponse;
    } on DioException catch (e) {
      String message = 'Login failed';
      if (e.response?.data != null) {
        var errData = e.response!.data;
        if (errData is Map<String, dynamic> && errData.containsKey('message')) {
          message = errData['message'];
        } else if (errData is List &&
            errData.isNotEmpty &&
            errData[0] is Map<String, dynamic>) {
          message = errData[0]['message'] ?? message;
        }
      }

      throw ApiError(
        message: message,
        statusCode: e.response?.statusCode,
        code: 'LOGIN_ERROR',
        originalError: e,
      );
    }
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
      developer.log(
        'Register API raw response: ${response.data}',
        name: 'AuthenticationService',
      );

      var data = response.data['data'];

      Map<String, dynamic> parsedData;
      if (data is Map<String, dynamic>) {
        parsedData = data;
      } else if (data is List &&
          data.isNotEmpty &&
          data[0] is Map<String, dynamic>) {
        parsedData = data[0];
      } else {
        throw ApiError(
          message: 'Unexpected response format',
          statusCode: response.statusCode,
          code: 'REGISTER_ERROR',
          originalError: null,
        );
      }

      final authResponse = await compute(parseAuthResponseIsolate, parsedData);

      await storage.write(key: 'jwt_token', value: authResponse.token);
      if (authResponse.refreshToken != null) {
        await storage.write(
          key: 'refresh_token',
          value: authResponse.refreshToken!,
        );
      }

      return authResponse;
    } on DioException catch (e) {
      developer.log(
        'Error response data: ${e.response?.data}',
        name: 'AuthenticationService',
      );

      String message = 'Registration failed';
      if (e.response?.data != null) {
        var errData = e.response!.data;
        if (errData is Map<String, dynamic> && errData.containsKey('message')) {
          message = errData['message'];
        } else if (errData is List &&
            errData.isNotEmpty &&
            errData[0] is Map<String, dynamic>) {
          message = errData[0]['message'] ?? message;
        }
      }

      throw ApiError(
        message: message,
        statusCode: e.response?.statusCode,
        code: 'REGISTER_ERROR',
        originalError: e,
      );
    }
  }

  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } on DioException catch (e) {
      developer.log(
        'Logout API error: ${e.message}',
        level: 900,
        name: 'AuthenticationService',
      );
    } finally {
      await storage.delete(key: 'jwt_token');
      await storage.delete(key: 'refresh_token');
    }
  }

  Future<String?> getToken() async => await storage.read(key: 'jwt_token');
  Future<bool> isAuthenticated() async =>
      (await getToken())?.isNotEmpty ?? false;
  Future<void> clearAuth() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'refresh_token');
  }
}
