import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/get_binding.dart';
import 'package:chat_app/screens/profile/profile.dart';
import 'package:chat_app/widgets/hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/widgets/hero_tags.dart';

class DrawerView extends StatelessWidget {
  final UserModel user = UserModel.fromLocalStorage();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: 270,
          height: Get.height,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                  Get.to(
                    () => ProfileScreen(userModel: user),
                    binding: GetBinding(),
                  );
                },
                child: Stack(
                  children: [
                    HeroWidget(
                      tag: HeroTags.imageTag(user),
                      child: CachedNetworkImage(
                        imageUrl: UserModel.fromLocalStorage().imageUrl,
                        placeholder: (context, url) => Image.asset(
                          'src/images/placeholder.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'src/images/placeholder.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                        height: 250,
                        width: 300,
                      ),
                    ),
                    PositionedDirectional(
                      bottom: 0,
                      start: 0,
                      end: 0,
                      child: Container(
                        color: Colors.black26,
                        alignment: AlignmentDirectional.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HeroWidget(
                            tag: HeroTags.nameTag(user),
                            child: Text(
                              UserModel.fromLocalStorage().name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.grey.shade700,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add_alt_1,
                      color: Colors.grey.shade700,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Invite Friends',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.help,
                      color: Colors.grey.shade700,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Help',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             Icons.nightlight_round,
              //             color: Colors.grey.shade700,
              //           ),
              //           SizedBox(
              //             width: 20,
              //           ),
              //           Text(
              //             'Night Mode',
              //             style: Theme.of(context).textTheme.bodyText1,
              //           ),
              //         ],
              //       ),
              //       GetBuilder<SettingsController>(
              //         builder: (controller) => Switch(
              //           value: controller.isDarkMode,
              //           onChanged: (value) {
              //             controller.changeTheme(value);
              //           },
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.find<HomeController>().logOut();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.grey.shade700,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'LogOut',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
