import 'dart:io';

import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/local_storage.dart';
import 'package:chat_app/data/country_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  RxBool obscureText = true.obs;
  File userImage;
  CountryModel userCountry;

  bool loading = false;

  List<CountryModel> _countries = AppUtilies().countriesList;

  List<CountryModel> getCountries() {
    _countries.removeWhere(
        (element) => element.code == 'All');
    return _countries;
  }

  setUserImage(File image) {
    userImage = image;
    update();
  }

  void addUserCountry(CountryModel countryModel) {
    print(countryModel.name);
    userCountry = countryModel;
    update();
  }

  Future<UserModel> editProfile(
    String name,
    String email,
    String phone,
    String bio,
  ) async {
    if (userCountry == null) {
      Fluttertoast.showToast(msg: 'Choose an your country');
      return null;
    }

    loading = true;
    update();
    UserModel userModel = await FirebaseApi()
        .editProfile(name, email, phone, userCountry.code, bio, userImage);
    if (userModel != null) {
      Get.find<SettingsController>().setUser(userModel);
      LocalStorage().setString(LocalStorage.user, userModel.toUserString());
      loading = false;
      update();
      return userModel;
    } else {
      loading = false;
      update();
      return null;
    }
  }
}
