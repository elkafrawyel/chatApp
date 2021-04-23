import 'dart:convert';

import 'package:chat_app/helper/local_storage.dart';

class UserModelFields {
  static String name = 'name';
  static String imageUrl = 'imageUrl';
  static String id = 'id';
  static String phone = 'phone';
  static String email = 'email';
  static String countryCode = 'countryCode';
  static String isOnline = 'isOnline';
  static String isTyping = 'isTyping';
  static String isRecording = 'isRecording';
  static String isSending = 'isSending';
  static String lastSeen = 'lastSeen';
  static String bio = 'bio';
  static String isMale = 'isMale';
  static String firebaseToken = 'firebaseToken';
}

class UserModel {
  String name;
  String imageUrl;
  String id;
  String phone;
  String email;
  String countryCode;
  bool isOnline;
  bool isTyping;
  bool isRecording;
  bool isSending;
  int lastSeen;
  String bio;
  bool isMale;
  String firebaseToken;

  UserModel(
    this.name,
    this.imageUrl,
    this.id,
    this.phone,
    this.email,
    this.countryCode,
    this.isOnline,
    this.lastSeen,
    this.isMale,
    this.bio,
    this.firebaseToken,
    this.isTyping,
    this.isSending,
    this.isRecording,
  );

  UserModel.fromJson(dynamic map) {
    id = map["id"];
    name = map["name"];
    isOnline = map["isOnline"];
    isTyping = map["isTyping"];
    isSending = map["isSending"];
    isRecording = map["isRecording"];
    lastSeen = map["lastSeen"];
    phone = map["phone"];
    email = map["email"];
    imageUrl = map["imageUrl"];
    countryCode = map["countryCode"];
    isMale = map["isMale"];
    bio = map["bio"];
    firebaseToken = map["firebaseToken"];
  }

  String toUserString() {
    return jsonEncode(toJson());
  }

  UserModel.fromLocalStorage() {
    String userString = LocalStorage().getString(LocalStorage.user);
    if (userString != null) {
      dynamic map = jsonDecode(userString);
      id = map["id"];
      name = map["name"];
      isOnline = map["isOnline"];
      email = map["email"];
      lastSeen = map["lastSeen"];
      phone = map["phone"];
      imageUrl = map["imageUrl"];
      countryCode = map["countryCode"];
      bio = map["bio"];
      firebaseToken = map["firebaseToken"];
      isMale = map["isMale"];
      isRecording = map["isRecording"];
      isSending = map["isSending"];
      isTyping = map["isTyping"];
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["isOnline"] = isOnline;
    map["lastSeen"] = lastSeen;
    map["email"] = email;
    map["phone"] = phone;
    map["imageUrl"] = imageUrl;
    map["firebaseToken"] = firebaseToken;
    map["countryCode"] = countryCode;
    map["bio"] = bio;
    map["isMale"] = isMale;
    map["isTyping"] = isTyping;
    map["isSending"] = isSending;
    map["isRecording"] = isRecording;

    return map;
  }
}
