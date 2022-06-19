import 'package:shared_preferences/shared_preferences.dart';

class TokenPreference {
  static void saveAddress(String key, String value) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  static Future<String> fetchAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    print(token);

    return token;
  }
}
