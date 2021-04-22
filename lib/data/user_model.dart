import 'dart:convert';

import 'package:chat_app/helper/local_storage.dart';

class UserModel {
  String name;
  String imageUrl;
  String id;
  String phone;
  String email;
  String countryCode;
  bool isOnline;
  int lastSeen;
  String bio;
  bool isMale;

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
  );

  UserModel.fromJson(dynamic map) {
    id = map["id"];
    name = map["name"];
    isOnline = map["isOnline"];
    lastSeen = map["lastSeen"];
    phone = map["phone"];
    email = map["email"];
    imageUrl = map["imageUrl"];
    countryCode = map["countryCode"];
    isMale = map["isMale"];
    bio = map["bio"];
  }

  String toUserString() {
    return jsonEncode(toJson());
  }

  UserModel.fromLocalStorage() {
    String userString = LocalStorage().getString(LocalStorage.user);
    if(userString!=null) {
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
      isMale = map["isMale"];
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
    map["countryCode"] = countryCode;
    map["bio"] = bio;
    map["isMale"] = isMale;

    return map;
  }

}
