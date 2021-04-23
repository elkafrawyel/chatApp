import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/data/chat_room.dart';
import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/get_binding.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatCard extends StatelessWidget {
  final ChatRoom chatRoom;

  ///user send message to me it can be from toId or fromId
  final UserModel messageSender;

  ChatCard(this.chatRoom, this.messageSender) {
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openChatScreen(messageSender);
        FirebaseApi.seeLastChatRoomMessage(chatRoom.lastMessage);
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 10, end: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CircularImage(
                  imageUrl: messageSender.imageUrl,
                  size: 70,
                ),
                //online view
                PositionedDirectional(
                  bottom: 0,
                  end: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            messageSender.isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 0,
                  end: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      AppUtilies()
                          .getCountryByKey(messageSender.countryCode)
                          .flag,
                      fit: BoxFit.cover,
                      width: 20,
                      height: 20,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      messageSender.name,
                      style: chatRoom.lastMessage.idFrom ==
                              UserModel.fromLocalStorage().id
                          ? Theme.of(context).textTheme.caption
                          : chatRoom.lastMessage.seen ?? false
                              ? Theme.of(context).textTheme.button
                              : Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chatRoom.lastMessage.idFrom ==
                                    UserModel.fromLocalStorage().id
                                ? 'You: ${chatRoom.lastMessage.message}'
                                : chatRoom.lastMessage.message,
                            style: chatRoom.lastMessage.idFrom ==
                                    UserModel.fromLocalStorage().id
                                ? Theme.of(context).textTheme.caption
                                : chatRoom.lastMessage.seen ?? false
                                    ? Theme.of(context).textTheme.button
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: chatRoom.unSeenMessagesCount > 0 &&
                      chatRoom.lastMessage.idFrom !=
                          UserModel.fromLocalStorage().id &&
                      !chatRoom.lastMessage.seen,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        chatRoom.unSeenMessagesCount.toString(),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  getMessageTime(chatRoom.lastMessage.createdAt),
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getMessageTime(int time) {
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    var formatter = DateFormat('hh:mm a');
    String formatted = formatter.format(date);
    return formatted;
  }

  void _openChatScreen(UserModel userModel) {
    Get.to(
      () => ChatScreen(userModel.id),
      binding: GetBinding(),
      duration: Duration(milliseconds: 500),
    );
  }
}
