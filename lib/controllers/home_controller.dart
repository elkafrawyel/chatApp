import 'package:chat_app/api/firebase_api.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/data/country_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  CountryModel selectedCountry;
  List<CountryModel> countries = [];
  List<UserModel> allUsers = [];
  List<UserModel> usersByCountry = [];

  // get online users
  getUsers() async {
    FirebaseFirestore.instance
        .collection('Users')
        // .where('isOnline', isEqualTo: true)
        .snapshots()
        .listen((dataSnapshot) async {

      print('-->Users Doc is changed');
      allUsers = dataSnapshot.docs
          .map((document) => UserModel.fromJson(document.data()))
          .toList();

      allUsers.sort((a, b) => a.name.compareTo(b.name));

      allUsers.removeWhere(
          (element) => element.id == UserModel.fromLocalStorage().id);

      countries = allUsers
          .map((user) => AppUtilies().getCountryByKey(user.countryCode))
          .toSet()
          .toList();

      countries.insert(0, AppUtilies().allWorldModel());

      if (selectedCountry == null) selectCountry(countries[0]);

      getUsersByCountry(selectedCountry);
    });
  }

  void selectCountry(CountryModel countryModel) {
    selectedCountry = countryModel;
    update();
    getUsersByCountry(selectedCountry);
  }

  void getUsersByCountry(CountryModel selectedCountry) {
    if (selectedCountry.code == 'all') {
      usersByCountry = allUsers;
      update();
    } else {
      usersByCountry = allUsers
          .where((element) => element.countryCode == selectedCountry.code)
          .toList();
      update();
    }
  }

  void logOut() {
    FirebaseApi().logOut();
  }
}
