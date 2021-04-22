import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/local_storage.dart';
import 'package:chat_app/screens/home/home.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool obscureText = true.obs;
  bool loading = false;

  void login(String email, String password) async {
    loading = true;
    update();
    UserModel userModel = await FirebaseApi().login(email, password);
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
