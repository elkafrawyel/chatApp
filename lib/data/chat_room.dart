import 'package:chat_app/data/super_message_model.dart';

class ChatRoomFields {
  static String unSeenMessagesCount = 'unSeenMessagesCount';
  static String lastMessage = 'lastMessage';
  static String time = 'time';
  static String opened = 'opened';
}

class ChatRoom {
  int unSeenMessagesCount;
  SuperMessage lastMessage;
  int time;
  bool opened;

  ChatRoom({this.unSeenMessagesCount, this.lastMessage, this.time,this.opened});

  static ChatRoom fromJson(Map<String, dynamic> json) => json == null
      ? null
      : ChatRoom(
          unSeenMessagesCount: json['unSeenMessagesCount'],
          time: json['time'],
          opened: json['opened'],
          lastMessage: json['lastMessage'] == null
              ? null
              : SuperMessage.fromJson(json['lastMessage']),
        );

  Map<String, dynamic> toJson() => {
        'opened': opened,
        'unSeenMessagesCount': unSeenMessagesCount,
        'time': time,
        'lastMessage': lastMessage == null ? null : lastMessage.toJson(),
      };
}
