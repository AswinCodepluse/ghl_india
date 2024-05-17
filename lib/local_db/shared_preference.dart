import 'package:ghl_callrecoding/models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", value);
  }

  Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  Future<void> setUserId(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", value);
  }

  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id") ?? "0";
  }

  Future<void> setUserName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_name", value);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_name") ?? "";
  }

  Future<void> setFilePath(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("file_path", value);
  }

  Future<String> getFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("file_path") ?? "";
  }

  Future<void> setUserData({required LoginResponse loginResponse}) async {
    setLogin(true);
    setUserId(loginResponse.user!.id!.toString());
    setUserName(loginResponse.user!.name!);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await setLogin(false);
    await prefs.remove("user_name");
    await prefs.remove("user_id");
  }
}
