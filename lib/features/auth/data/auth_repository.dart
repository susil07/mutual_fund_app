import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'token';

  AuthRepository({FlutterSecureStorage? storage}) 
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    // Basic validation is handled in UI/Bloc
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // Store dummy token
    await _storage.write(key: _tokenKey, value: 'dummy_token_$email');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}
