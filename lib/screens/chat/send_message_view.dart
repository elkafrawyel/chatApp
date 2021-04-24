import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:get/get.dart';
import 'package:chat_app/controllers/chat_controller.dart';

class SendMessageView extends StatefulWidget {
  final UserModel userModel ;

  SendMessageView({@required this.userModel});

  @override
  _SendMessageViewState createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  final TextEditingController controller = TextEditingController();
  var canSendMessage = false;
  final chatController = Get.find<ChatController>();
  var keyboardOpened = false;

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(seconds: 2)}) {
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey)
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 10, end: 10),
                            child: TextField(
                              minLines: 1,
                              maxLines: 8,
                              textCapitalization: TextCapitalization.sentences,
                              autocorrect: true,
                              enableSuggestions: true,

                              controller: controller,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    value.trim().isNotEmpty) {
                                  setState(() {
                                    canSendMessage = true;
                                  });
                                } else {
                                  setState(() {
                                    canSendMessage = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: 'Write message',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !canSendMessage,
                          child: SlideInRight(
                            child: IconButton(
                              icon: Icon(
                                Icons.photo_camera,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _openCamera();
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _openBottomSheet();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  key: UniqueKey(),
                  onTap: !canSendMessage
                      ? null
                      : () {
                          String messageText = controller.text.isEmpty
                              ? null
                              : controller.text.trim();
                          setState(() {
                            controller.text = '';
                            canSendMessage = false;
                          });
                          _sendMessage(
                            message: messageText,
                            media: [],
                          );
                        },
                  child: Container(
                    decoration: BoxDecoration(
                        color: canSendMessage
                            ? StaticValues.appColor
                            : Colors.grey,
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    if (keyboardOpened) {
      Get.back();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  _openCamera() async {
    List<Media> media = await ImagesPicker.openCamera(
      pickType: PickType.all,
      maxTime: 15, // record video max time
    );

    // _sendMessage(
    //   message: controller.text.isEmpty ? null : controller.text.trim(),
    //   media: media,
    // );
    setState(() {
      controller.text = '';
      canSendMessage = false;
    });
  }

  void _selectVideo() async {
    List<Media> media = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.video,
    );

    // _sendMessage(
    //   message: controller.text.isEmpty ? null : controller.text.trim(),
    //   media: media,
    // );
    setState(() {
      controller.text = '';
      canSendMessage = false;
    });
  }

  void _selectImages() async {
    List<Media> media = await ImagesPicker.pick(
      count: 10,
      pickType: PickType.image,
    );

    // _sendMessage(
    //   message: controller.text.isEmpty ? null : controller.text.trim(),
    //   media: media,
    // );
    setState(() {
      controller.text = '';
      canSendMessage = false;
    });
  }

  void _sendMessage({String message, List<Media> media}) async{
    FocusScope.of(context).unfocus();
    // await FirebaseApi.uploadMessage(widget.userModel,message);
    controller.clear();
  }

  void _openBottomSheet() {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.image,
                    color: StaticValues.appColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'image'.tr,
                    style:
                        TextStyle(fontSize: 16, color: StaticValues.appColor),
                  ),
                ],
              ),
            ),
            onTap: () async {
              _selectImages();
              Get.back();
            },
          ),
          InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.video_call, color: StaticValues.appColor),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'video'.tr,
                      style:
                          TextStyle(fontSize: 16, color: StaticValues.appColor),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                _selectVideo();
                Get.back();
              }),
        ],
      ),
    );
  }
}
