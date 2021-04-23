import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:flutter/material.dart';

class ReplyMessageWidget extends StatelessWidget {
  final SuperMessage message;
  final bool isMe;
  final VoidCallback onCancelReply;
  final UserModel user;

  const ReplyMessageWidget({
    @required this.message,
    this.onCancelReply,
    @required this.isMe,
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Container(
              color: isMe ? Colors.green : Colors.white,
              width: 4,
            ),
            const SizedBox(width: 8),
            Expanded(child: buildReplyMessage()),
          ],
        ),
      );

  Widget buildReplyMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  '${message.idFrom == user.id ? user.name : UserModel.fromLocalStorage().name}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black54 : Colors.white),
                ),
              ),
              if (onCancelReply != null)
                GestureDetector(
                  child: Icon(Icons.close, size: 16),
                  onTap: onCancelReply,
                )
            ],
          ),
          const SizedBox(height: 8),
          Text(message.message,
              style: TextStyle(color: isMe ? Colors.black54 : Colors.white)),
        ],
      );
}
