import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:swipe_to/swipe_to.dart';

import 'message_widget.dart';

class MessagesList extends StatefulWidget {
  final ValueChanged<SuperMessage> onSwipedMessage;

  MessagesList({
    @required this.onSwipedMessage,
  });

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final UserModel me = UserModel.fromLocalStorage();
  final ScrollController scrollController = ScrollController();
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) => GetBuilder<ChatController>(
        builder: (controller) => controller.messagesList == null
            ? Center(child: CircularProgressIndicator())
            : controller.messagesList.isEmpty
                ? Center(
                    child: Text(
                      'Say Hi!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  )
                : ListView.separated(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(12),
                    itemBuilder: (BuildContext context, int index) {
                      final message = controller.messagesList[index];

                      // if (!message.seen &&
                      //     message.idUser !=
                      //         UserModel.fromLocalStorage().id) {
                      //   // not seen and is not my message
                      //   FirebaseApi()
                      //       .seeSingleMessage(userId, message.id);
                      // }
                      return SwipeTo(
                        onRightSwipe: () => widget.onSwipedMessage(message),
                        child: MessageWidget(
                          message: message,
                          isMe: message.idFrom == me.id,
                          user: chatController.userModel,
                        ),
                      );
                    },
                    itemCount: controller.messagesList.length,
                    reverse: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                  ),
      );

// void play() async {
//   await AssetsAudioPlayer.newPlayer().open(
//     Audio("src/sounds/whatsapp_tone.mp3"),
//   );
// }
}
