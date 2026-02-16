import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:alumns_app/features/auth/models/api_models.dart';
import 'package:alumns_app/core/api/api_service_manager.dart';

/// API Service Helper Utility
///
/// Provides convenient methods for common API operations
/// with error handling and user feedback
class ApiHelper {
  /// Perform login with error handling
  static Future<AuthResponse?> performLogin({
    required BuildContext context,
    required String email,
    required String password,
    VoidCallback? onSuccess,
    Function(ApiError)? onError,
  }) async {
    try {
      final response = await ApiService.auth.login(
        email: email,
        password: password,
      );
      onSuccess?.call();
      return response;
    } on ApiError catch (e) {
      onError?.call(e);
      if (context.mounted) {
        _showErrorSnackBar(context, e.message);
      }
      return null;
    }
  }

  /// Perform registration with error handling
  static Future<AuthResponse?> performRegister({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    VoidCallback? onSuccess,
    Function(ApiError)? onError,
  }) async {
    try {
      final response = await ApiService.auth.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      onSuccess?.call();
      return response;
    } on ApiError catch (e) {
      onError?.call(e);
      if (context.mounted) {
        _showErrorSnackBar(context, e.message);
      }
      return null;
    }
  }

  /// Perform logout with error handling
  static Future<void> performLogout({
    required BuildContext context,
    VoidCallback? onSuccess,
    Function(ApiError)? onError,
  }) async {
    try {
      await ApiService.auth.logout();
      onSuccess?.call();
    } on ApiError catch (e) {
      onError?.call(e);
      if (context.mounted) {
        _showErrorSnackBar(context, e.message);
      }
    }
  }

  /// Get user profile with error handling
  static Future<User?> getUserProfile({
    required BuildContext context,
    Function(ApiError)? onError,
  }) async {
    try {
      final user = await ApiService.user.getUserProfile();
      return user;
    } on ApiError catch (e) {
      onError?.call(e);
      if (context.mounted) {
        _showErrorSnackBar(context, e.message);
      }
      return null;
    }
  }

  /// Update user profile with error handling
  static Future<User?> updateProfile({
    required BuildContext context,
    String? name,
    String? phone,
    String? avatar,
    String? bio,
    VoidCallback? onSuccess,
    Function(ApiError)? onError,
  }) async {
    try {
      final user = await ApiService.user.updateUserProfile(
        name: name,
        phone: phone,
        avatar: avatar,
        bio: bio,
      );
      onSuccess?.call();
      return user;
    } on ApiError catch (e) {
      onError?.call(e);
      if (context.mounted) {
        _showErrorSnackBar(context, e.message);
      }
      return null;
    }
  }

  /// Track page view
  static Future<void> trackPageView({
    required String pageName,
    String? userId,
    String? sessionId,
  }) async {
    try {
      await ApiService.pageView.trackPageView(
        pageName: pageName,
        userId: userId,
        sessionId: sessionId,
      );
    } catch (e) {
      developer.log(
        'Error tracking page view: $e',
        level: 900,
        name: 'ApiHelper',
      );
    }
  }

  /// Get page view count
  static Future<PageViewCountResponse?> getPageViewCount({
    required String pageName,
    Function(ApiError)? onError,
  }) async {
    try {
      return await ApiService.pageView.getPageViewCount(pageName: pageName);
    } on ApiError catch (e) {
      onError?.call(e);
      return null;
    }
  }

  /// Show error snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  /// Close loading dialog
  static void closeLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

/// API Service Extension
///
/// Provides extension methods for common operations
extension ApiServiceExtension on BuildContext {
  /// Get API Service Manager
  ApiServiceManager get apiManager => ApiService.manager;

  /// Track page view for current page
  void trackPageView(String pageName) {
    ApiHelper.trackPageView(pageName: pageName);
  }

  /// Show error snackbar
  void showError(String message) {
    ApiHelper._showErrorSnackBar(this, message);
  }

  /// Show success snackbar
  void showSuccess(String message) {
    ApiHelper.showSuccessSnackBar(this, message);
  }

  /// Show loading dialog
  void showLoading({String message = 'Loading...'}) {
    ApiHelper.showLoadingDialog(this, message: message);
  }

  /// Close loading dialog
  void closeLoading() {
    ApiHelper.closeLoadingDialog(this);
  }
}
