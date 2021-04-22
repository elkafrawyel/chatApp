import 'dart:convert';

import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/helper/get_binding.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    _firebaseMessaging.getToken().then((token) {
      print('token:$token');
      //save token to user doc
      FirebaseApi.setFirebaseToken(token);
    });

    if (!_initialized) {
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('@mipmap/ic_launcher');

      var initializationSettingsIOS = IOSInitializationSettings();
      var initializationSettingsMAC = MacOSInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
          macOS: initializationSettingsMAC);

      _localNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('--onMessage--');

        if (message.notification != null) {
          print('Message Notification: ${message.notification}');
        }

        if (message.data != null) {
          print('Message Data: ${message.data}');
        }

        showNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('--onMessageOpenedApp--');

        if (message.notification != null) {
          print('Message Notification: ${message.notification.title}');
        }

        if (message.data != null) {
          print('Message Data: ${message.data}');
        }

        showNotification(message);
      });

      // FirebaseMessaging.onBackgroundMessage(
      //     _firebaseMessagingBackgroundHandler);

      _initialized = true;
    }
  }

  handleBackGroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();

    print('--on Background Message--');

    if (message.notification != null) {
      print('Message Notification: ${message.notification}');
    }

    if (message.data != null) {
      print('Message Data: ${message.data}');
    }

    showNotification(message);
  }

  Future onSelectNotification(String payload) async {
    //message data as json string
    Map<String, dynamic> data = json.decode(payload);
    print('Message payload : ${data['formId']}');
    Get.to(
      () => ChatScreen(data['fromId']),
      binding: GetBinding(),
      duration: Duration(milliseconds: 1000),
    );
  }

  void showNotification(RemoteMessage message) async {
    //if chat and user is in chat screen no notifications allowed
    //and allow to show notification
    if (Get.find<SettingsController>().showNotification &&
        message.data['type'] == 'chat') {
    } else {
      String title = message.notification.title;
      String body = message.notification.body;
      String payload = json.encode(message.data);
      await _demoNotification(title, body, payload);
    }
  }

  Future<void> _demoNotification(
      String title, String body, String payload) async {
    String _channelId = "com.chat.app";
    String _channelName = "chat";
    String _channelDesc = "Dating App";

    var androidChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDesc,
        importance: Importance.max,
        playSound: true,
        priority: Priority.high,
        showWhen: true,
        autoCancel: true,
        enableVibration: true,
        visibility: NotificationVisibility.public);

    var iOSChannelSpecifics = IOSNotificationDetails();
    var channelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
    await _localNotificationsPlugin.show(1995, title, body, channelSpecifics,
        payload: payload);

    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
    );
  }
}
