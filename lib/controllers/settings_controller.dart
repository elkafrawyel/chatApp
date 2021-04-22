import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  UserModel userModel;
  bool isDarkMode = LocalStorage().getBool(LocalStorage.darkMode);

  @override
  void onInit() async {
    userModel = await FirebaseApi().getUserProfile();
    if (userModel != null) {
      LocalStorage().setString(LocalStorage.user, userModel.toUserString());
      FirebaseApi().setUserOnlineState(true);
    }
    setTheme();
    super.onInit();
  }

  void setUser(UserModel userModel) {
    this.userModel = userModel;
    update();
  }

  void setTheme() {
    if (isDarkMode) {
      Get.changeTheme(ThemeData.dark());
      print('switch to dark mode');
    } else {
      Get.changeTheme(ThemeData.light());
      print('switch to light mode');
    }
    update();
  }

  void changeTheme(bool darkMode) {
    isDarkMode = darkMode;
    LocalStorage().setBool(LocalStorage.darkMode, darkMode);
    if (darkMode) {
      Get.changeTheme(ThemeData.dark());
      print('switch to dark mode');
    } else {
      Get.changeTheme(ThemeData.light());
      print('switch to light mode');
    }
    update();
  }
}
