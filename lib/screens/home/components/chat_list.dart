import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/screens/home/components/chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperMessage>>(
        stream: FirebaseApi.getMyChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text(
                'Something Went Wrong Try Later.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          } else {
            if (snapshot.hasData) {
              final messages = snapshot.data;
              return messages.length == 0
                  ? Center(
                      child: Text(
                        'You Don\'t Have Any Recent Messages.',
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final id =
                              message.idFrom == UserModel.fromLocalStorage().id
                                  ? message.idTo
                                  : message.idFrom;
                          return FutureBuilder<UserModel>(
                            future: FirebaseApi().getUserProfile(id: id),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return SizedBox();
                              } else {
                                return ChatCard(message, snapshot.data);
                              }
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          height: 20,
                        ),
                      ),
                    );
            } else {
              return SizedBox();
            }
          }
        });
  }
}
