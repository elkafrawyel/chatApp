import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/helper/get_binding.dart';
import 'package:chat_app/helper/local_storage.dart';
import 'package:chat_app/screens/auth/login.dart';
import 'package:chat_app/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'helper/static_values.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: StaticValues.appColor,
        accentColor: StaticValues.appColor,
      ),
      onDispose: () {
        FirebaseApi().setUserOnlineState(false);
      },
      initialBinding: GetBinding(),
      // defaultTransition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 1000),
      home: LocalStorage().getBool(LocalStorage.isLoggedIn)
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
