import 'dart:io';

import 'package:chat_app/controllers/register_controller.dart';
import 'package:chat_app/data/country_model.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/widgets/register_countries_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class RegisterScreen extends StatelessWidget {
  final controller = Get.find<RegisterController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: Get.width,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    _photo(),
                    SizedBox(
                      height: 30,
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
                    _passwordField(),
                    SizedBox(
                      height: 20,
                    ),
                    RegisterCountriesMenu(),
                    SizedBox(
                      height: 20,
                    ),
                    _gender(),
                    SizedBox(
                      height: 40,
                    ),
                    _registerButton(),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<RegisterController>(
            builder: (controller) => Visibility(
              visible: controller.loading,
              child: Container(
                color: Colors.black38,
                height: Get.height,
                width: Get.width,
                child: Center(
                  child: CircularProgressIndicator(
                    // backgroundColor: Colors.white,
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

  _passwordField() => Container(
        width: Get.width - 50,
        color: Colors.white,
        child: Obx(() => TextFormField(
              obscureText: controller.obscureText.value,
              style: TextStyle(fontSize: 14, color: Colors.black),
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is empty';
                } else if (value.length < 6) {
                  return 'Weak password';
                } else {
                  return null;
                }
              },
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                contentPadding: EdgeInsets.all(16),
                alignLabelWithHint: true,
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: _eyeView(),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.0, color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            )),
      );

  _eyeView() => GestureDetector(
        onTap: () {
          controller.obscureText.value = !controller.obscureText.value;
        }, //call this method when contact with screen is removed
        child: Icon(
            controller.obscureText.value
                ? Icons.visibility
                : Icons.visibility_off,
            size: 18,
            color: Colors.grey),
      );

  _registerButton() => Container(
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
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );

  void _register() {
    if (formKey.currentState.validate()) {
      FocusScope.of(scaffoldKey.currentContext).unfocus();
      formKey.currentState.save();

      controller.registerNewUser(
        nameController.text,
        emailController.text,
        phoneController.text,
        passwordController.text,
      );
    }
  }

  _photo() => Padding(
        padding: const EdgeInsets.all(20),
        child: GetBuilder<RegisterController>(
          builder: (controller) => controller.userImage == null
              ? Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: StaticValues.appColor, width: 5),
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: StaticValues.appColor,
                      ),
                      onPressed: () async {
                        List<Media> media = await ImagesPicker.pick(
                          count: 1,
                          pickType: PickType.image,
                        );
                        if (media != null) {
                          controller.setUserImage(File(media.first.path));
                        }
                      }),
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

  _gender() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: true,
              groupValue: controller.isMale.value,
              activeColor: StaticValues.appColor,
              onChanged: (value) {
                controller.isMale.value = value;
              },
            ),
            Text(controller.male, style: TextStyle(fontSize: 18)),
            Radio(
              activeColor: StaticValues.appColor,
              value: false,
              groupValue: controller.isMale.value,
              onChanged: (value) {
                controller.isMale.value = value;
              },
            ),
            Text(controller.female, style: TextStyle(fontSize: 18)),
          ],
        ));
  }
}
