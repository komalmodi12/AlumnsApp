/// API Configuration for Alumns App
class ApiConfig {
  // Production API endpoints
  static const String productionBaseUrl = 'https://alumns.com';
  static const String qaBaseUrl = 'https://alumns-qa-render.onrender.com';

  // API endpoints
  static const String apiV1 = '/api/v1';
  static const String api = '/api';

  // Auth endpoints
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';

  // User endpoints
  static const String userProfile = '/user';
  static const String users = '/users';

  // Pageview endpoints
  static const String pageViewCount = '/pageview/count';
  static const String pageViewIncrement = '/pageview/increment';

  // Default to QA for development
  static String getBaseUrl({bool useQa = true}) {
    return useQa ? qaBaseUrl : productionBaseUrl;
  }
}
