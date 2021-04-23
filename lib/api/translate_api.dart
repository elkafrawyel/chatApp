import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:translator/translator.dart';

class TranslateApi {
  static translate(SuperMessage message) async {
    try {
      UserModel userModel = UserModel.fromLocalStorage();
      String userLanguage = userModel.countryCode;
      Translation translation = await GoogleTranslator()
          .translate(message.message, to: userLanguage.toLowerCase());
      FirebaseApi.saveTranslatedMessage(message, translation.text);
      print('Translation --> ${translation.text}');
    } catch (ex) {
      return 'Translation error';
    }
  }
}
