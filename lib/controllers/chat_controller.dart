import 'dart:async';

import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  UserModel _userModel;
  List<SuperMessage> _messagesList;

  UserModel get userModel => _userModel;

  List<SuperMessage> get messagesList => _messagesList;

  setUserId(String userId) {
    FirebaseApi.singleUserStream(userId).listen((snapshot) {
      _userModel = UserModel.fromJson(snapshot.data());
      update();
      FirebaseApi.getMessagesStream(_userModel.id).listen((messages) {
        _messagesList = messages;
        update();
      });
    });
  }

  goOffline() {
    Get.showSnackbar(
      GetBar(
        backgroundColor: Colors.red.shade400,
        // title: 'disConnectedTitle'.tr,
        messageText: Text(
          'No internet connection',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.perm_scan_wifi_outlined,
          color: Colors.white,
          size: 25,
        ),
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
      ),
    );
  }

  Future<bool> _checkNetwork() async {
    switch (await DataConnectionChecker().connectionStatus) {
      case DataConnectionStatus.disconnected:
        return false;
      case DataConnectionStatus.connected:
        return true;
      default:
        return false;
    }
  }
}
