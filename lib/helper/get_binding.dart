import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/controllers/login_controller.dart';
import 'package:chat_app/controllers/register_controller.dart';
import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/controllers/edit_profile_controller.dart';
import 'package:get/get.dart';

class GetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController(), permanent: true);
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => EditProfileController());
    Get.lazyPut(() => ChatController());
  }
}
