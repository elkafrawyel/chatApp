import 'package:chat_app/data/user_model.dart';

class HeroTags {
  static String imageTag(UserModel userModel) => userModel.name + userModel.id;
  static String nameTag(UserModel userModel) => userModel.id + userModel.name;
}
