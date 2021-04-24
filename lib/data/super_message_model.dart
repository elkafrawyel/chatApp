import 'package:flutter/material.dart';

class MessageField {
  static final String idMessage = 'idMessage';
  static final String message = 'message';
  static final String createdAt = 'createdAt';
  static final String translatedMessage = 'translatedMessage';
  static final String seen = 'seen';
}

class SuperMessage {
  String idMessage;
  String idTo;
  String idFrom;
  String message;
  String translatedMessage;
  int createdAt;
  bool seen;
  SuperMessage replyMessage;

  SuperMessage({
    this.idMessage,
    @required this.idTo,
    @required this.idFrom,
    @required this.message,
    @required this.translatedMessage,
    @required this.createdAt,
    @required this.replyMessage,
    @required this.seen,
  });

  static SuperMessage fromJson(Map<String, dynamic> json) => SuperMessage(
        idMessage: json['idMessage'],
        idTo: json['idTo'],
        idFrom: json['idFrom'],
        message: json['message'],
        translatedMessage: json['translatedMessage'],
        createdAt: json['createdAt'],
        replyMessage: json['replyMessage'] == null
            ? null
            : SuperMessage.fromJson(json['replyMessage']),
        seen: json['seen'],
      );

  Map<String, dynamic> toJson() => {
        'idMessage': idMessage,
        'idTo': idTo,
        'idFrom': idFrom,
        'message': message,
        'translatedMessage': translatedMessage,
        'createdAt': createdAt,
        'seen': seen,
        'replyMessage': replyMessage == null ? null : replyMessage.toJson(),
      };
}
