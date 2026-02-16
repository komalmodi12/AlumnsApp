import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:alumns_app/features/auth/models/api_models.dart';

/// PageView Analytics Service
///
/// Tracks page views and analytics for the Alumns app
/// Uses QA endpoint: https://alumns-qa-render.onrender.com/api/v1/pageview
class PageViewService {
  final Dio dio;
  final String baseUrl;

  PageViewService({required this.dio, required this.baseUrl});

  /// Get page view count for a specific page
  ///
  /// GET: /api/v1/pageview/count?pageName=home
  Future<PageViewCountResponse> getPageViewCount({
    required String pageName,
  }) async {
    try {
      final response = await dio.get(
        '/api/v1/pageview/count',
        queryParameters: {'pageName': pageName},
      );

      if (response.data is Map<String, dynamic>) {
        return PageViewCountResponse.fromJson(response.data);
      } else if (response.data is List) {
        // Handle if response is wrapped in array
        return PageViewCountResponse.fromJson(response.data[0]);
      }

      throw ApiError(
        message: 'Invalid response format for page view count',
        statusCode: response.statusCode,
        code: 'INVALID_RESPONSE',
      );
    } on DioException catch (e) {
      throw ApiError(
        message:
            e.response?.data['message'] ?? 'Failed to fetch page view count',
        statusCode: e.response?.statusCode,
        code: 'PAGEVIEW_COUNT_ERROR',
        originalError: e,
      );
    }
  }

  /// Increment page view count for a specific page
  ///
  /// POST: /api/v1/pageview/increment
  Future<PageViewIncrementResponse> incrementPageView({
    required String pageName,
    String? userId,
    String? sessionId,
  }) async {
    try {
      final response = await dio.post(
        '/api/v1/pageview/increment',
        data: {
          'pageName': pageName,
          if (userId != null) 'userId': userId,
          if (sessionId != null) 'sessionId': sessionId,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return PageViewIncrementResponse.fromJson(response.data);
      } else if (response.data is List) {
        // Handle if response is wrapped in array
        return PageViewIncrementResponse.fromJson(response.data[0]);
      }

      throw ApiError(
        message: 'Invalid response format for page view increment',
        statusCode: response.statusCode,
        code: 'INVALID_RESPONSE',
      );
    } on DioException catch (e) {
      throw ApiError(
        message: e.response?.data['message'] ?? 'Failed to increment page view',
        statusCode: e.response?.statusCode,
        code: 'PAGEVIEW_INCREMENT_ERROR',
        originalError: e,
      );
    }
  }

  /// Track page navigation
  ///
  /// Combines getting the current count and incrementing it
  Future<void> trackPageView({
    required String pageName,
    String? userId,
    String? sessionId,
  }) async {
    try {
      // First increment the page view
      await incrementPageView(
        pageName: pageName,
        userId: userId,
        sessionId: sessionId,
      );

      // Optionally get updated count
      final count = await getPageViewCount(pageName: pageName);
      developer.log(
        'Page view tracked for "$pageName" - Total views: ${count.count}',
        name: 'PageViewService',
      );
    } catch (e) {
      developer.log(
        'Error tracking page view: $e',
        level: 900,
        name: 'PageViewService',
      );
      // Don't throw - this is optional analytics
    }
  }

  /// Get analytics for multiple pages
  ///
  /// Useful for dashboard or overview pages
  Future<List<PageViewCountResponse>> getMultiplePageViews({
    required List<String> pageNames,
  }) async {
    try {
      final futures = pageNames.map((name) => getPageViewCount(pageName: name));
      final results = await Future.wait(futures);
      return results;
    } catch (e) {
      throw ApiError(
        message: 'Failed to fetch multiple page views',
        code: 'MULTIPLE_PAGEVIEW_ERROR',
        originalError: e,
      );
    }
  }
}
