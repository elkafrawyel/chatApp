import 'package:chat_app/data/super_message_model.dart';

class ChatRoomFields {
  static String unSeenMessagesCount = 'unSeenMessagesCount';
  static String lastMessage = 'lastMessage';
  static String time = 'time';
}

class ChatRoom {
  int unSeenMessagesCount;
  SuperMessage lastMessage;
  int time;

  ChatRoom({this.unSeenMessagesCount, this.lastMessage, this.time});

  static ChatRoom fromJson(Map<String, dynamic> json) => json == null
      ? null
      : ChatRoom(
          unSeenMessagesCount: json['unSeenMessagesCount'],
          time: json['time'],
          lastMessage: json['lastMessage'] == null
              ? null
              : SuperMessage.fromJson(json['lastMessage']),
        );

  Map<String, dynamic> toJson() => {
        'unSeenMessagesCount': unSeenMessagesCount,
        'time': time,
        'lastMessage': lastMessage == null ? null : lastMessage.toJson(),
      };
}
