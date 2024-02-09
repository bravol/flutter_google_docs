import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  Future<void> setToken(String token) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('x-auth-token', token);
    } catch (e) {
      print('Error storing token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('x-auth-token');
      return token;
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }
}
