import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chat_app/screens/chat/components/reply_message_widget.dart';

class MessageWidget extends StatelessWidget {
  final SuperMessage message;
  final bool isMe;
  final UserModel user;

  const MessageWidget({
    @required this.message,
    @required this.isMe,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe) CircularImage(imageUrl: user.imageUrl, size: 30),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsetsDirectional.only(
              top: 16, bottom: 16, start: 8, end: 18),
          constraints: BoxConstraints(maxWidth: width * 3 / 4),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : StaticValues.appColor,
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() {
    final messageWidget = SelectableLinkify(
      onOpen: (link) async {
        if (await canLaunch(link.url)) {
          await launch(link.url);
        } else {
          throw 'Could not launch $link';
        }
      },
      text: message.message.trim(),
      textAlign: TextAlign.start,
      style: TextStyle(color: isMe ? Colors.black : Colors.white,fontSize: 18),
      linkStyle: TextStyle(color: Colors.green,fontSize: 18),
    );

    if (message.replyMessage == null) {
      return messageWidget;
    } else {
      return Column(
        crossAxisAlignment: isMe && message.replyMessage == null
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          buildReplyMessage(),
          messageWidget,
        ],
      );
    }
  }

  Widget buildReplyMessage() {
    final replyMessage = message.replyMessage;
    final isReplying = replyMessage != null;

    if (!isReplying) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: ReplyMessageWidget(
          message: replyMessage,
          isMe: isMe,
          user: user,
        ),
      );
    }
  }
}
