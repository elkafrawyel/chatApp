import 'package:chat_app/helper/Utilies.dart';
import 'package:flutter/material.dart';

class MessageField {
  static final String idMessage = 'idMessage';
  static final String message = 'message';
  static final String createdAt = 'createdAt';
}

class SuperMessage {
  final String idMessage;
  final String idTo;
  final String idFrom;
  final String message;
  final int createdAt;
  final SuperMessage replyMessage;

  const SuperMessage({
    this.idMessage,
    @required this.idTo,
    @required this.idFrom,
    @required this.message,
    @required this.createdAt,
    @required this.replyMessage,
  });

  static SuperMessage fromJson(Map<String, dynamic> json) => SuperMessage(
        idMessage: json['idMessage'],
        idTo: json['idTo'],
        idFrom: json['idFrom'],
        message: json['message'],
        createdAt: json['createdAt'],
        replyMessage: json['replyMessage'] == null
            ? null
            : SuperMessage.fromJson(json['replyMessage']),
      );

  Map<String, dynamic> toJson() => {
        'idMessage': idMessage,
        'idTo': idTo,
        'idFrom': idFrom,
        'message': message,
        'createdAt': createdAt,
        'replyMessage': replyMessage == null ? null : replyMessage.toJson(),
      };
}
