import 'dart:io';

import 'package:chat_app/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'logging_interceptor.dart';

class NotificationCenter {
  final String _serverKey =
      'AAAAYA_141c:APA91bEbp4B-UtvlyaBIUPykwJxny1eBewYc9_nIZIzeFTyaLxA1C_seQdp6V6944mvDxALq0QQxLZYsOQPPvRHP814QQdiJDFzakYEh-R7xNDl60Ojox7ioCN_znSXagigo_gBF6oqS';

  Future<Dio> _getDioClient() async {
    BaseOptions options = new BaseOptions(
      baseUrl: "https://fcm.googleapis.com/fcm",
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cacheControlHeader: 'no-Cache',
        HttpHeaders.authorizationHeader: 'key=$_serverKey',
      },
      connectTimeout: 50000,
      receiveTimeout: 50000,
    );

    Dio _dio = Dio(options);
    _dio.interceptors.add(LoggingInterceptor());

    return _dio;
  }

  sendNotification(
    String idUser,
    String title,
    String body,
    NotificationType notificationType,
  ) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(idUser)
          .get();
      String firebaseToken = UserModel.fromJson(snapshot.data()).firebaseToken;

      if (firebaseToken == null) return;
      Response response = await (await _getDioClient()).post("/send", data: {
        /// this is optional - used to send to one device
        'to': firebaseToken,
        'notification': {
          'title': title,
          'body': body,
          'priority': 'high',
          'sound': 'tone',
        },
        'data': {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          'type': notificationType == NotificationType.CHAT
              ? 'chat'
              : 'notification',
          'fromId': UserModel.fromLocalStorage().id,
        }
      });

      if (response.statusCode == 200) {
        print(response.data);
      } else {
        print('Error');
      }
    } on DioError catch (ex) {
      print('${ex.message}');
    }
  }
}

enum NotificationType {
  CHAT,
  NOTIFICATION,
}
