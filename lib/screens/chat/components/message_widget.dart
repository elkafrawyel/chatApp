import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
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
    final icon = (message.seen ?? false) ? Icons.done_all : Icons.done;
    final iconColor = Colors.black;
    final textColor = isMe ? Colors.black : Colors.white;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe) CircularImage(imageUrl: user.imageUrl, size: 30),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsetsDirectional.only(
              top: 16, bottom: 16, start: 8, end: 18),
          constraints: BoxConstraints(maxWidth: width * 3 / 4),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : StaticValues.appColor,
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: new BoxConstraints(
                    minHeight: 25,
                    minWidth: 100,
                    // maxHeight: 30.0,
                    maxWidth: MediaQuery.of(context).size.width * .7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    // _images(),
                    // _video(),
                    buildMessage(textColor),
                  ],
                ),
              ),
              PositionedDirectional(
                end: 0,
                bottom: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 10),
                      child: Text(
                        AppUtilies().getDateStringHhMmA(message.createdAt),
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .apply(color: isMe ? Colors.black : Colors.white),
                      ),
                    ),
                    SizedBox(width: 3.0),
                    Visibility(
                      visible: isMe,
                      child: Icon(
                        icon,
                        size: 20.0,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMessage(textColor) {
    final messageWidget = message.message == null
        ? SizedBox()
        : LayoutBuilder(builder: (context, constraints) {
            final placeholderText = '                  \u202F';
            final messagePainter = TextPainter(
              text: TextSpan(
                  text: message.message, style: TextStyle(fontSize: 20)),
              textDirection: TextDirection.ltr,
              textWidthBasis: TextWidthBasis.longestLine,
            )..layout(maxWidth: constraints.maxWidth);

            final timePainter = TextPainter(
              text: TextSpan(
                  text: message.message + placeholderText,
                  style: TextStyle(fontSize: 20)),
              textDirection: TextDirection.ltr,
              textWidthBasis: TextWidthBasis.longestLine,
            )..layout(maxWidth: constraints.maxWidth);

            final changeLine = timePainter.minIntrinsicWidth.ceilToDouble() >
                    messagePainter.minIntrinsicWidth.ceilToDouble() + 0.001 ||
                timePainter.height > messagePainter.height + 0.001;

            return Padding(
              padding:
                  const EdgeInsetsDirectional.only(start: 4, end: 8, top: 8),
              child: SelectableLinkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: changeLine
                    ? message.message + placeholderText
                    : message.message + placeholderText,
                textAlign: TextAlign.start,
                style: TextStyle(color: textColor, fontSize: 20),
                linkStyle: TextStyle(color: Colors.green),
              ),
            );
          });

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
