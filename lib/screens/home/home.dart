import 'dart:async';
import 'package:chat_app/api/notification_center.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/screens/home/components/drawer.dart';
import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/screens/home/components/country_filter.dart';
import 'package:chat_app/screens/home/components/online_users.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/chat_list.dart';
import 'components/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final settingController = Get.find<SettingsController>();
  final homeController = Get.put(HomeController());
  StreamSubscription<DataConnectionStatus> _checker;
  bool isOnline = true;
  ScrollController scrollController;
  bool silverCollapsed = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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

    scrollController = ScrollController();

    scrollController.addListener(() {
      //check if app bar is Collapsed to change content
      if (scrollController.offset > 80 &&
          !scrollController.position.outOfRange) {
        if (!silverCollapsed) {
          // do what ever you want when silver is collapsing !
          silverCollapsed = true;
          setState(() {});
        }
      }

      //check if app bar is Expanded to change content
      if (scrollController.offset <= 80 &&
          !scrollController.position.outOfRange) {
        if (silverCollapsed) {
          // do what ever you want when silver is expanding !
          silverCollapsed = false;
          setState(() {});
        }
      }

      // check if user reached page bottom to load more
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        print('load more');
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    homeController.getUsers();
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //set status to online here in fireStore
      FirebaseApi().setUserOnlineState(true);
      Get.find<SettingsController>().setShowNotification(false);

    } else {
      // set status to offline here in fireStore
      FirebaseApi().setUserOnlineState(false);
      Get.find<SettingsController>().setShowNotification(true);
    }
  }

  @override
  void dispose() {
    _checker.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(context: context, delegate: Search());
              })
        ],
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
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            offlineView(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  child: Text(
                    'Online Users',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CountryFilter(),
                )
              ],
            ),
            OnlineUsersListView(),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: Text(
                'Recent',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Expanded(child: ChatListView())
          ],
        ),
      ),
      drawer: DrawerView(),
    );
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
