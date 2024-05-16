import 'dart:convert';

import '../app_config.dart';
import 'package:http/http.dart' as http;

import '../models/login_response_model.dart';
import '../models/logout_response_model.dart';
import '../models/password_confirm_response.dart';
import '../models/password_forgot_model.dart';
import '../models/resend_code_model.dart';
import '../utils/shared_value.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      String? email, String password, String loginBy) async {
    // Define the URL for your API endpoint
    var url = Uri.parse('https://sales.ghlindia.com/api/auth/login');

    // Define your POST request body
    var post_body = jsonEncode({
      "email": "${email}",
      "password": "$password",
      // "identity_matrix": AppConfig.purchase_code,
      "login_by": loginBy,
      "role": "staff"
    });

    try {
      // Make the POST request
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: post_body,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        return loginResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        // Return a default LoginResponse or throw an exception
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here if needed
      print('Exception occurred: $e');
      throw e; // Rethrow the exception
    }
  }

  Future<LoginResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});

    var url = Uri.parse("${AppConfig.BASE_URL}/auth/get-user-by-access-token");
    try {
      // Make the POST request
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: post_body,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        return loginResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        // Return a default LoginResponse or throw an exception
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here if needed
      print('Exception occurred: $e');
      throw e; // Rethrow the exception
    }
  }

  Future<LogoutResponse> getLogoutResponse() async {
    final response = await http.get(
      Uri.parse('${AppConfig.BASE_URL}/api/auth/logout'),
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );
    print("response Logout---->${response.body}");

    if (response.statusCode == 200) {
      return logoutResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load leads');
    }
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      String verification_code, String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    var url =
        Uri.parse("${AppConfig.BASE_URL}/api/auth/password/confirm_reset");
    try {
      // Make the POST request
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        return passwordConfirmResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        // Return a default LoginResponse or throw an exception
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here if needed
      print('Exception occurred: $e');
      throw e; // Rethrow the exception
    }
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      String? email_or_code, String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    var url = Uri.parse("${AppConfig.BASE_URL}/api/auth/password/resend_code");
    try {
      // Make the POST request
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        return resendCodeResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        // Return a default LoginResponse or throw an exception
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here if needed
      print('Exception occurred: $e');
      throw e; // Rethrow the exception
    }
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      String? email_or_phone, String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    var url =
        Uri.parse("${AppConfig.BASE_URL}/api/auth/password/forget_request");
    try {
      // Make the POST request
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        return passwordForgetResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        // Return a default LoginResponse or throw an exception
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here if needed
      print('Exception occurred: $e');
      throw e; // Rethrow the exception
    }
  }
}
