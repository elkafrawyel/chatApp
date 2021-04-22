import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/screens/home/components/search.dart';
import 'package:chat_app/screens/home/components/search_view.dart';
import 'package:chat_app/screens/profile/profile.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatelessWidget {
  final bool silverCollapsed;

  AppBarWidget({this.silverCollapsed});

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            showSearch(context: context, delegate: Search());
          })
    ];

    return SliverAppBar(
      actions: actions,
      title: Opacity(
        opacity: 1,
        // opacity: silverCollapsed ? 1 : 0,
        child: Text(
          'Chats',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      brightness: Brightness.dark,
      backgroundColor: StaticValues.appColor,
      // expandedHeight: 200.0,
      pinned: true,
      floating: true,
      elevation: 0,
      // flexibleSpace: FlexibleSpaceBar(
      //   background: Stack(
      //     children: [
      //       Image.asset(
      //         'src/images/appbar_bg.png',
      //         width: Get.width,
      //         height: 300,
      //         fit: BoxFit.cover,
      //       ),
      //       Container(
      //         color: Colors.black26,
      //         alignment: AlignmentDirectional.bottomCenter,
      //         child: SearchView(),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
