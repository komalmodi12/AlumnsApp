import '../../core/api/api_client.dart';
import 'models/auth_models.dart';

class AuthService {
  final ApiClient api;

  AuthService(this.api);

  Future<LoginResponse> login(String email, String password) async {
    final resp = await api.dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    final body = resp.data as Map<String, dynamic>;
    final lr = LoginResponse.fromJson(body);
    await api.storage.write(key: 'jwt', value: lr.token);
    return lr;
  }

  Future<Map<String, dynamic>> profile() async {
    final resp = await api.dio.get('/profile');
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<void> logout() async {
    await api.storage.delete(key: 'jwt');
  }
}
