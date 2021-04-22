import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final String isLoggedIn = 'isLogin';
  static final String user = 'user';
  static final String darkMode = 'darkMode';

  setString(String key, String value) async {
    await GetStorage().write(key, value);
  }

  String getString(String key) {
    return GetStorage().read(key);
  }

  setBool(String key, bool value) async {
    await GetStorage().write(key, value);
  }

  bool getBool(String key) {
    bool value = GetStorage().read(key);
    return value == null ? false : value;
  }

  setInt(String key, int value) async {
    await GetStorage().write(key, value);
  }

  int getInt(String key) {
    return GetStorage().read(key) == null ? 0 : GetStorage().read(key);
  }

  clear() {
    GetStorage().erase();
  }
}
