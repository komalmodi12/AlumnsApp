import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage storage;

  ApiClient._(this.dio, this.storage);

  factory ApiClient(String baseUrl) {
    final storage = FlutterSecureStorage();
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'jwt');
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            await storage.delete(key: 'jwt');
          }
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return ApiClient._(dio, storage);
  }
}
