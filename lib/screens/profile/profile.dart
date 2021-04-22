import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/get_binding.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:chat_app/widgets/hero_widget.dart';
import 'package:chat_app/screens/edit_profile/edit_profile.dart';
import 'package:chat_app/widgets/hero_tags.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;

  ProfileScreen({@required this.userModel});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final settingController = Get.find<SettingsController>();
  final double circleRadius = 150.0;
  final double circleBorderWidth = 8.0;
  UserModel userModel;
  bool me;

  @override
  void initState() {
    userModel = widget.userModel;
    me = UserModel.fromLocalStorage().id == userModel.id;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: StaticValues.appColor,
        actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffE0E0E0),
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: circleRadius / 2.0,
                  ),

                  ///here we create space for the circle avatar to get ut of the box
                  child: Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: circleRadius / 2,
                            ),
                            HeroWidget(
                              tag: HeroTags.nameTag(userModel),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    end: 20, start: 20),
                                child: Text(
                                  userModel.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  end: 20, start: 20),
                              child: Text(
                                userModel.bio != null
                                    ? userModel.bio
                                    : 'No Bio',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.lightBlueAccent),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[],
                              ),
                            )
                          ],
                        )),
                  ),
                ),

                ///edit icon
                PositionedDirectional(
                  end: 0,
                  top: circleRadius / 2,
                  child: Visibility(
                    visible: me,
                    child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          UserModel updatedUser = await Get.to(
                            () => EditProfileScreen(),
                            binding: GetBinding(),
                          );
                          if (updatedUser != null) {
                            setState(() {
                              userModel = updatedUser;
                            });
                          }
                        }),
                  ),
                ),

                ///user country
                PositionedDirectional(
                  top: circleRadius / 2,
                  start: 0,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: AppUtilies()
                                  .getCountryByKey(userModel.countryCode)
                                  .name);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              AppUtilies()
                                  .getCountryByKey(userModel.countryCode)
                                  .flag,
                              fit: BoxFit.cover,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      userModel.isMale
                          ? Image.asset(
                              'src/images/male.png',
                              width: 25,
                              height: 25,
                            )
                          : Image.asset(
                              'src/images/female.png',
                              width: 25,
                              height: 25,
                            )
                    ],
                  ),
                ),

                ///Image Avatar
                Container(
                  width: circleRadius,
                  height: circleRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0.0, 5.0),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: StaticValues.appColor,
                      ),
                      child: HeroWidget(
                        tag: HeroTags.imageTag(userModel),
                        child: CircularImage(
                          imageUrl: userModel.imageUrl,
                          size: 150,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
