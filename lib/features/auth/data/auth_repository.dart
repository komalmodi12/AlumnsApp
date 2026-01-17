class AuthRepository {
  /// Simulates a login call. Replace with real API call.
  Future<bool> login({required String id, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock behavior: accept if id == 'user' and password == 'pass'
    return id == 'user' && password == 'pass';
  }
}
