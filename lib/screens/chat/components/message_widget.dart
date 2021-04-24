import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chat_app/screens/chat/components/reply_message_widget.dart';
import 'package:chat_app/api/translate_api.dart';

class MessageWidget extends StatefulWidget {
  final SuperMessage message;
  final bool isMe;
  final UserModel user;

  const MessageWidget({
    @required this.message,
    @required this.isMe,
    @required this.user,
  });

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final width = MediaQuery.of(context).size.width;
    final icon = (widget.message.seen ?? false) ? Icons.done_all : Icons.done;
    final iconColor = Colors.green;
    final textColor = widget.isMe ? Colors.black : Colors.white;

    return Column(
      crossAxisAlignment:
          widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            if (!widget.isMe)
              CircularImage(imageUrl: widget.user.imageUrl, size: 30),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsetsDirectional.only(
                  top: 8, bottom: 8, start: 8, end: 0),
              constraints: BoxConstraints(maxWidth: width * 0.7),
              decoration: BoxDecoration(
                color: widget.isMe ? Colors.grey[100] : StaticValues.appColor,
                borderRadius: widget.isMe
                    ? borderRadius
                        .subtract(BorderRadius.only(bottomRight: radius))
                    : borderRadius
                        .subtract(BorderRadius.only(bottomLeft: radius)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: widget.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // _images(),
                  // _video(),
                  buildMessage(textColor),
                  if (!widget.isMe) buildTranslatedMessage(textColor),
                ],
              ),
            ),
            if (!widget.isMe && widget.message.translatedMessage == null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.translate,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      await TranslateApi.translate(
                        widget.message,
                      );
                    }),
              ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 40),
            Text(
              AppUtilies().getDateStringHhMmA(widget.message.createdAt),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Colors.black45),
            ),
            SizedBox(width: 3.0),
            Visibility(
              visible: widget.isMe,
              child: Icon(
                icon,
                size: 20.0,
                color: iconColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMessage(textColor) {
    final messageWidget = widget.message.message == null
        ? SizedBox()
        : Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 8, top: 8),
            child: SelectableLinkify(
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },
              text: widget.message.message,
              textAlign: TextAlign.start,
              style: TextStyle(color: textColor, fontSize: 20),
              linkStyle: TextStyle(color: Colors.green),
            ),
          );

    if (widget.message.replyMessage == null) {
      return messageWidget;
    } else {
      return Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.5),
        child: Column(
          crossAxisAlignment: widget.isMe && widget.message.replyMessage == null
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            buildReplyMessage(),
            messageWidget,
          ],
        ),
      );
    }
  }

  Widget buildTranslatedMessage(textColor) {
    final messageWidget = widget.message.translatedMessage == null
        ? SizedBox()
        : Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 4,
              end: 8,
            ),
            child: SelectableLinkify(
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },
              text: widget.message.translatedMessage,
              textAlign: TextAlign.start,
              style: TextStyle(color: textColor, fontSize: 20),
              linkStyle: TextStyle(color: Colors.green),
            ),
          );

    return messageWidget;
  }

  Widget buildReplyMessage() {
    final replyMessage = widget.message.replyMessage;
    final isReplying = replyMessage != null;

    if (!isReplying) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(maxWidth: Get.width * 0.7),
        child: ReplyMessageWidget(
          message: replyMessage,
          isMe: widget.isMe,
          user: widget.user,
        ),
      );
    }
  }
}
