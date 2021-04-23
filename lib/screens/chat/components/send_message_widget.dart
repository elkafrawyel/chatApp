import 'dart:async';

import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/screens/chat/components/reply_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class SendMessageWidget extends StatefulWidget {
  final FocusNode focusNode;
  final SuperMessage replyMessage;
  final VoidCallback onCancelReply;

  const SendMessageWidget({
    @required this.focusNode,
    @required this.replyMessage,
    @required this.onCancelReply,
    Key key,
  }) : super(key: key);

  @override
  _SendMessageWidgetState createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final _controller = TextEditingController();
  String message = '';
  final chatController = Get.find<ChatController>();

  static final inputTopRadius = Radius.circular(12);
  static final inputBottomRadius = Radius.circular(24);

  void sendMessage() async {
    widget.onCancelReply();
    FirebaseApi.isTyping(false);
    await FirebaseApi.uploadMessage(
        chatController.userModel.id, message, widget.replyMessage);

    _controller.clear();
  }

  // @override
  // void dispose() {
  //   FirebaseApi.isTyping(false);
  //   super.dispose();
  // }

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);

        if (visible) {
          FirebaseApi.isTyping(true);
        } else {
          widget.focusNode.unfocus();
          FirebaseApi.isTyping(false);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = widget.replyMessage != null;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                if (isReplying) buildReply(),
                TextField(
                  focusNode: widget.focusNode,
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  style: Theme.of(context).textTheme.bodyText1,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: isReplying ? Radius.zero : inputBottomRadius,
                        topRight: isReplying ? Radius.zero : inputBottomRadius,
                        bottomLeft: inputBottomRadius,
                        bottomRight: inputBottomRadius,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    message = value;
                  }),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: message.trim().isEmpty ? null : sendMessage,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: StaticValues.appColor,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReply() => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: inputTopRadius,
            topRight: inputTopRadius,
          ),
        ),
        child: ReplyMessageWidget(
          message: widget.replyMessage,
          onCancelReply: widget.onCancelReply,
          user: chatController.userModel,
          isMe: true, //to make its text color black
        ),
      );
}
