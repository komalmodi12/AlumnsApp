import 'package:dio/dio.dart';
import 'package:alumns_app/features/auth/models/api_models.dart';

/// User Management Service
///
/// Handles user profile operations and user-related API calls
/// Endpoints: /api/user, /api/users
class UserService {
  final Dio dio;
  final String baseUrl;

  UserService({required this.dio, required this.baseUrl});

  /// Get current user profile
  ///
  /// GET: /api/user or /user
  Future<User> getUserProfile() async {
    try {
      final response = await dio.get('/api/user');

      if (response.data is Map<String, dynamic>) {
        return User.fromJson(response.data);
      }

      throw ApiError(
        message: 'Invalid response format for user profile',
        statusCode: response.statusCode,
        code: 'INVALID_RESPONSE',
      );
    } on DioException catch (e) {
      throw ApiError(
        message: e.response?.data['message'] ?? 'Failed to fetch user profile',
        statusCode: e.response?.statusCode,
        code: 'USER_PROFILE_ERROR',
        originalError: e,
      );
    }
  }

  /// Update user profile
  ///
  /// PUT: /api/user
  Future<User> updateUserProfile({
    String? name,
    String? phone,
    String? avatar,
    String? bio,
  }) async {
    try {
      final response = await dio.put(
        '/api/user',
        data: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (avatar != null) 'avatar': avatar,
          if (bio != null) 'bio': bio,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return User.fromJson(response.data);
      }

      throw ApiError(
        message: 'Invalid response format for profile update',
        statusCode: response.statusCode,
        code: 'INVALID_RESPONSE',
      );
    } on DioException catch (e) {
      throw ApiError(
        message: e.response?.data['message'] ?? 'Failed to update user profile',
        statusCode: e.response?.statusCode,
        code: 'UPDATE_PROFILE_ERROR',
        originalError: e,
      );
    }
  }

  /// Get all users (if available)
  ///
  /// GET: /api/users
  Future<List<User>> getAllUsers({int? page, int? limit}) async {
    try {
      final response = await dio.get(
        '/api/users',
        queryParameters: {
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        // Handle paginated response
        if (response.data['data'] is List) {
          return (response.data['data'] as List)
              .map((json) => User.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }

      throw ApiError(
        message: 'Invalid response format for users list',
        statusCode: response.statusCode,
        code: 'INVALID_RESPONSE',
      );
    } on DioException catch (e) {
      throw ApiError(
        message: e.response?.data['message'] ?? 'Failed to fetch users',
        statusCode: e.response?.statusCode,
        code: 'USERS_LIST_ERROR',
        originalError: e,
      );
    }
  }

  /// Get user by ID
  ///
  /// GET: /api/users/:id
  Future<User> getUserById(int userId) async {
    try {
      final response = await dio.get('/api/users/$userId');

      if (response.data is Map<String, dynamic>) {
        return User.fromJson(response.data);
      }

      throw ApiError(
        message: 'Invalid response format for user',
        statusCode: response.statusCode,
        code: 'INVALID_RESPONSE',
      );
    } on DioException catch (e) {
      throw ApiError(
        message: e.response?.data['message'] ?? 'Failed to fetch user',
        statusCode: e.response?.statusCode,
        code: 'GET_USER_ERROR',
        originalError: e,
      );
    }
  }

  /// Delete current user account
  ///
  /// DELETE: /api/user
  Future<void> deleteAccount() async {
    try {
      await dio.delete('/api/user');
    } on DioException catch (e) {
      throw ApiError(
        message: e.response?.data['message'] ?? 'Failed to delete account',
        statusCode: e.response?.statusCode,
        code: 'DELETE_ACCOUNT_ERROR',
        originalError: e,
      );
    }
  }

  /// Change password
  ///
  /// POST: /api/user/change-password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await dio.post(
        '/api/user/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw ApiError(
        message: e.response?.data['message'] ?? 'Failed to change password',
        statusCode: e.response?.statusCode,
        code: 'CHANGE_PASSWORD_ERROR',
        originalError: e,
      );
    }
  }
}
