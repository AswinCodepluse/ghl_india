import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/helpers/auth_helpers.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/repositories/auth_repositories.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:ghl_callrecoding/views/auth/login_page.dart';
import 'package:toast/toast.dart';

class AuthController extends GetxController {
  Future<void> logout(context) async {
    AuthHelper authHelper = AuthHelper();
    SharedPreference sharedPreference = SharedPreference();
    var logoutResponse = await AuthRepository().getLogoutResponse();
    if (logoutResponse.result == true) {
      authHelper.clearUserData();
      await sharedPreference.clearUserData();
      ToastComponent.showDialog(logoutResponse.message!.toString(),
          gravity: Toast.center, duration: Toast.lengthLong);
      Get.offAll(() => LoginPage());
    } else {
      ToastComponent.showDialog(logoutResponse.message!.toString(),
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
