import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'online_user.dart';

class OnlineUsersListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: EdgeInsetsDirectional.only(end: 8),
      width: Get.width,
      child: GetBuilder<HomeController>(
        builder: (controller) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return OnlineUserCard(controller.usersByCountry[index]);
          },
          itemCount: controller.usersByCountry.length,
        ),
      ),
    );
  }
}
