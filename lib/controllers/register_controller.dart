import 'dart:io';

import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/local_storage.dart';
import 'package:chat_app/screens/home/home.dart';
import 'package:chat_app/data/country_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:chat_app/api/firebase_api.dart';

class RegisterController extends GetxController {
  //New Users Static data

  RxBool obscureText = true.obs;
  final String male = 'Male';
  final String female = 'Female';
  RxBool isMale = true.obs;
  File userImage;
  CountryModel userCountry;

  bool loading = false;
  List<CountryModel> _countries = [];

  List<CountryModel> get countries => _countries;

  @override
  onInit() {
    super.onInit();
    _countries = AppUtilies().countriesList;
    _countries.removeWhere((element) => element.code == 'All');
  }

  setUserImage(File image) {
    userImage = image;
    update();
  }

  void addUserCountry(CountryModel countryModel) {
    print(countryModel.name);
    userCountry = countryModel;
    print(userCountry.name);
    update();
  }

  registerNewUser(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    if (userImage == null) {
      Fluttertoast.showToast(msg: 'Choose a profile picture');
      return;
    }
    if (userCountry == null) {
      Fluttertoast.showToast(msg: 'Choose an your country');
      return;
    }

    loading = true;
    update();
    UserModel userModel = await FirebaseApi().createNewUser(name, email, phone,
        password, isMale.value, userCountry.code, userImage);
    if (userModel != null) {
      Get.find<SettingsController>().setUser(userModel);
      FirebaseApi().setUserOnlineState(true);
      LocalStorage().setBool(LocalStorage.isLoggedIn, true);
      LocalStorage().setString(LocalStorage.user, userModel.toUserString());
      Get.offAll(() => HomeScreen());
    } else {}
    loading = false;
    update();
  }
}
