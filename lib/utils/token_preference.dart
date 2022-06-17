import 'package:shared_preferences/shared_preferences.dart';

class TokenPreference {
  static void saveAddress(String token) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", token);
  }

  static Future<String?> fetchAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    print(token);

    return token;
  }
}
