import 'package:chat_app/controllers/login_controller.dart';
import 'package:chat_app/helper/get_binding.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:chat_app/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
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
                    Image.asset('src/images/logo.png'),
                    _emailField(),
                    SizedBox(
                      height: 20,
                    ),
                    _passwordField(),
                    SizedBox(
                      height: 20,
                    ),
                    _loginButton(),
                    SizedBox(
                      height: 10,
                    ),
                    _registerButton(),
                    SizedBox(
                      height: 20,
                    ),
                    Text('or continue with'),
                    SizedBox(
                      height: 20,
                    ),
                    _socialApps()
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<LoginController>(
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

  _passwordField() => Container(
        width: Get.width - 50,
        color: Colors.white,
        child: Obx(() => TextFormField(
              obscureText: controller.obscureText.value,
              style: TextStyle(fontSize: 14, color: Colors.black),
              controller: passwordController,
              keyboardType: TextInputType.emailAddress,
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

  _loginButton() => Container(
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
            _login();
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
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
            Get.to(() => RegisterScreen(), binding: GetBinding());
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

  void _login() {
    if (formKey.currentState.validate()) {
      FocusScope.of(scaffoldKey.currentContext).unfocus();
      formKey.currentState.save();
      controller.login(emailController.text, passwordController.text);
    }
  }

  _socialApps() => Container(
        width: Get.width - 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {},
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'src/images/facebook.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'src/images/google.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'src/images/twitter.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
