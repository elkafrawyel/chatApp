import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/get_binding.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:chat_app/widgets/hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/widgets/hero_tags.dart';

class OnlineUserCard extends StatelessWidget {
  final UserModel userModel;

  OnlineUserCard(this.userModel);

  final settingController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openChatScreen(userModel);
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: 120, maxHeight: 120),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 8, end: 8, top: 10),
          child: Column(
            children: [
              Stack(
                children: [
                  HeroWidget(
                    tag: HeroTags.imageTag(userModel),
                    child: CircularImage(
                      imageUrl: userModel.imageUrl,
                      size: 70,
                    ),
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
                              userModel.isOnline ? Colors.green : Colors.grey,
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
                            .getCountryByKey(userModel.countryCode)
                            .flag,
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HeroWidget(
                    tag: HeroTags.nameTag(userModel),
                    child: Text(
                      userModel.name,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Colors.black),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openChatScreen(UserModel userModel) {
    Get.to(
      () => ChatScreen(userModel),
      binding: GetBinding(),
      duration: Duration(milliseconds: 1000),
    );
  }
}
