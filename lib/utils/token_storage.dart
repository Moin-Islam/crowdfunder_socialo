import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final storage = FlutterSecureStorage();

  static const setToken = 'token';

  static Future ssetToken(String token) async {
    await storage.write(key: setToken, value: token);
  }

  static Future<String?> getToken() async {
    await storage.read(key: setToken);
  }
}
