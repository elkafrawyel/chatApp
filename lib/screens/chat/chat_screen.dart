import 'dart:async';

import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/screens/profile/profile.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:chat_app/widgets/hero_tags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/widgets/hero_widget.dart';

import 'components/messages_list_view.dart';
import 'components/new_message_widget.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModel;

  ChatScreen(this.userModel);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SuperMessage replyMessage;
  final focusNode = FocusNode();
  bool isOnline = true;
  StreamSubscription<DataConnectionStatus> _checker;
  final chatController = Get.find<ChatController>();

  @override
  void dispose() {
    _checker.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _checker = DataConnectionChecker().onStatusChange.listen((event) {
      switch (event) {
        case DataConnectionStatus.connected:
          setState(() {
            isOnline = true;
          });
          break;

        case DataConnectionStatus.disconnected:
          setState(() {
            isOnline = false;
          });
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (chatController.userModel == null)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // executes after build
        chatController.setUserModel(widget.userModel);
      });
    return Scaffold(
      appBar: _buildAppbar(),
      backgroundColor: Color(0xFFECEBEB),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('src/images/chat_bg.png'), fit: BoxFit.cover),
        ),
        child: GetBuilder<ChatController>(
          builder: (controller) => controller.userModel == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    offlineView(),
                    Expanded(
                      child: MessagesList(
                        onSwipedMessage: (message) {
                          replyToMessage(message);
                          focusNode.requestFocus();
                        },
                      ),
                    ),
                    NewMessageWidget(
                      focusNode: focusNode,
                      onCancelReply: cancelReply,
                      replyMessage: replyMessage,
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _buildAppbar() => AppBar(
        title: GetBuilder<ChatController>(
          builder: (controller) => appBarTitle(controller.userModel == null
              ? widget.userModel
              : controller.userModel),
        ),
        backgroundColor: StaticValues.appColor,
        titleSpacing: 0.0,
        brightness: Brightness.dark,
      );

  void replyToMessage(SuperMessage message) {
    setState(() {
      replyMessage = message;
    });
  }

  appBarTitle(UserModel userModel) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ProfileScreen(userModel: userModel),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: HeroWidget(
                tag: HeroTags.imageTag(userModel),
                child: CircularImage(
                  imageUrl: userModel.imageUrl,
                  size: 40,
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroWidget(
                tag: HeroTags.nameTag(userModel),
                child: Text(
                  userModel.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              ),
              Text(
                userModel.isOnline
                    ? 'online'
                    : AppUtilies().timeAgoSinceDate(userModel.lastSeen),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }

  offlineView() => Visibility(
        visible: !isOnline,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi,
                  color: Colors.red,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'No internet connection',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      );
}
