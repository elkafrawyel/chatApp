import 'dart:io';

import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:chat_app/widgets/edit_profile_countries_menu.dart';
import 'package:chat_app/widgets/hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/controllers/edit_profile_controller.dart';
import 'package:images_picker/images_picker.dart';
import 'package:chat_app/widgets/hero_tags.dart';

class EditProfileScreen extends StatelessWidget {
  final controller = Get.find<EditProfileController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final UserModel me = UserModel.fromLocalStorage();

  EditProfileScreen() {
    //set user data to fields
    nameController.text = me.name;
    emailController.text = me.email;
    phoneController.text = me.phone;
    bioController.text = me.bio;
    controller.addUserCountry(AppUtilies().getCountryByKey(me.countryCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: StaticValues.appColor,
        title: Text('Edit Profile'),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _photo(),
                    SizedBox(
                      height: 20,
                    ),
                    _nameField(),
                    SizedBox(
                      height: 20,
                    ),
                    _emailField(),
                    SizedBox(
                      height: 20,
                    ),
                    _phoneField(),
                    SizedBox(
                      height: 20,
                    ),
                    _bioField(),
                    SizedBox(
                      height: 20,
                    ),
                    EditProfileCountriesMenu(
                      userCountry: AppUtilies().getCountryByKey(me.countryCode),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    _saveButton(),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<EditProfileController>(
            builder: (controller) => Visibility(
              visible: controller.loading,
              child: Container(
                color: Colors.black38,
                height: Get.height,
                width: Get.width,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _nameField() => Container(
        width: Get.width - 50,
        color: Colors.white,
        child: TextFormField(
          style: TextStyle(fontSize: 14, color: Colors.black),
          controller: nameController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is empty';
            } else {
              return null;
            }
          },
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'Full Name',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            contentPadding: EdgeInsets.all(16),
            alignLabelWithHint: true,
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
            prefixIcon: Icon(Icons.perm_identity),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.0, color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );

  _bioField() => Container(
        width: Get.width - 50,
        color: Colors.white,
        child: TextFormField(
          style: TextStyle(fontSize: 14, color: Colors.black),
          controller: bioController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'Bio is empty';
          //   } else {
          //     return null;
          //   }
          // },
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Bio',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            contentPadding: EdgeInsets.all(16),
            alignLabelWithHint: true,
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
            prefixIcon: Icon(Icons.edit_outlined),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.0, color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );

  _emailField() => Container(
        width: Get.width - 50,
        color: Colors.white,
        child: TextFormField(
          style: TextStyle(fontSize: 14, color: Colors.black),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is empty';
            } else if (!GetUtils.isEmail(value)) {
              return 'Invalid email format';
            } else {
              return null;
            }
          },
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'Email Address',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            contentPadding: EdgeInsets.all(16),
            alignLabelWithHint: true,
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.0, color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );

  _phoneField() => Container(
        width: Get.width - 50,
        color: Colors.white,
        child: TextFormField(
          style: TextStyle(fontSize: 14, color: Colors.black),
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone is empty';
            } else if (!GetUtils.isPhoneNumber(value)) {
              return 'Invalid phone format';
            } else {
              return null;
            }
          },
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'Phone Number',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            contentPadding: EdgeInsets.all(16),
            alignLabelWithHint: true,
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.0, color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );

  _saveButton() => Container(
        width: 200,
        child: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: StaticValues.appColor,
            onSurface: Colors.grey,
            elevation: 1.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
          onPressed: () {
            _register();
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Save changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );

  void _register() async {
    if (formKey.currentState.validate()) {
      FocusScope.of(scaffoldKey.currentContext).unfocus();
      formKey.currentState.save();

      UserModel userModel = await controller.editProfile(
          nameController.text,
          emailController.text,
          phoneController.text,
          bioController.text.isEmpty
              ? 'Write some words about you'
              : bioController.text);
      if (userModel != null) {
        Get.back(result: userModel);
      }
    }
  }

  _photo() => Padding(
        padding: const EdgeInsets.all(20),
        child: GetBuilder<EditProfileController>(
          builder: (controller) => controller.userImage == null
              ? InkWell(
                  onTap: () async {
                    List<Media> media = await ImagesPicker.pick(
                      count: 1,
                      pickType: PickType.image,
                    );
                    if (media != null) {
                      controller.setUserImage(File(media.first.path));
                    }
                  },
                  child: HeroWidget(
                    tag: HeroTags.imageTag(me),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: StaticValues.appColor, width: 5),
                      ),
                      child: CircularImage(imageUrl: me.imageUrl, size: 120),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () async {
                    List<Media> media = await ImagesPicker.pick(
                      count: 1,
                      pickType: PickType.image,
                    );
                    if (media != null) {
                      controller.setUserImage(File(media.first.path));
                    }
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: StaticValues.appColor, width: 5),
                      image: DecorationImage(
                          image: FileImage(controller.userImage),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
        ),
      );
}
