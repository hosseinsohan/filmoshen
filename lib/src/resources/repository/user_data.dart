import 'package:shared_preferences/shared_preferences.dart';

Future<bool> deleteToken() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.setString("mobile", "");
  prefs.setString("token", "").then((bool success) {
    return success;
  });
  return false;
}

Future<bool> saveToken(String mobile, String token) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.setString("mobile", mobile);
  prefs.setString("token", token).then((bool success) {
    return success;
  });
  return false;
}

Future<GetTokenAndMobile> getToken() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  var token = prefs.getString("token") ?? "";
  var mobile = prefs.getString("mobile") ?? "";
  if (token == null || token == "") {
    return null;
  }
  return GetTokenAndMobile(mobile, token);
}

class GetTokenAndMobile {
  final String token;
  final String mobile;
  GetTokenAndMobile(this.mobile, this.token);
}
