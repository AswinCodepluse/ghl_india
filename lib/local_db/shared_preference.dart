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
    setToken(loginResponse.accessToken!);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await setLogin(false);
    await prefs.remove("call_recording_folder_path");
    await prefs.remove("user_name");
    await prefs.remove("user_id");
    await prefs.remove("device_token");
    await prefs.remove("remainder_date");
    await prefs.remove("remainder_time");
    await prefs.remove("token");
  }

  Future<void> setRemainderDate(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("remainder_date", value);
  }

  Future<String> getRemainderDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("remainder_date") ?? "";
  }

  Future<void> setRemainderTime(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("remainder_time", value);
  }

  Future<String> getRemainderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("remainder_time") ?? "";
  }

  Future<void> setDeviceToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("device_token", value);
  }

  Future<String> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("device_token") ?? "";
  }

  Future<void> setCallRecordingFolderPath(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("call_recording_folder_path", value);
  }

  Future<String> getCallRecordingFolderPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("call_recording_folder_path") ?? "";
  }

  Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", value);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
