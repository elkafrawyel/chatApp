import 'package:flutter/material.dart';

class MessageField {
  static final String idMessage = 'idMessage';
  static final String message = 'message';
  static final String createdAt = 'createdAt';
  static final String seen = 'seen';
}

class SuperMessage {
  final String idMessage;
  final String idTo;
  final String idFrom;
  final String message;
  final int createdAt;
  final bool seen;
  final SuperMessage replyMessage;


  const SuperMessage({
    this.idMessage,
    @required this.idTo,
    @required this.idFrom,
    @required this.message,
    @required this.createdAt,
    @required this.replyMessage,
    @required this.seen,
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
        seen: json['seen'],
      );

  Map<String, dynamic> toJson() => {
        'idMessage': idMessage,
        'idTo': idTo,
        'idFrom': idFrom,
        'message': message,
        'createdAt': createdAt,
        'seen': seen,
        'replyMessage': replyMessage == null ? null : replyMessage.toJson(),
      };
}
