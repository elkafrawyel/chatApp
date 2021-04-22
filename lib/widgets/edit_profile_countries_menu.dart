import 'package:chat_app/controllers/edit_profile_controller.dart';
import 'package:chat_app/controllers/register_controller.dart';
import 'package:chat_app/data/country_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class EditProfileCountriesMenu extends StatefulWidget {
  final CountryModel userCountry;

  EditProfileCountriesMenu({this.userCountry});

  @override
  _EditProfileCountriesMenuState createState() =>
      _EditProfileCountriesMenuState();
}

class _EditProfileCountriesMenuState extends State<EditProfileCountriesMenu> {
  final List<DropdownMenuItem> items = [];

  CountryModel country;

  @override
  void initState() {
    super.initState();
    items.addAll(
      Get.find<RegisterController>().countries.map(
            (e) => DropdownMenuItem(
              //must pass each item value
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(e.flag),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    e.name,
                    maxLines: 2,
                    style: TextStyle(fontSize: 18),
                  )),
                ],
              ),
            ),
          ),
    );
    country = widget.userCountry;
  }

  @override
  Widget build(BuildContext context) {
    // for search to work override toString in class model
    return Center(
      child: SearchableDropdown.single(
        items: items,
        value: country,
        hint: "Select your country",
        searchHint: "Search for your country",
        onChanged: (value) {
          print(value);
          setState(() {
            country = value;
            Get.find<EditProfileController>().addUserCountry(value);
          });
        },
        isExpanded: true,
      ),
    );
  }
}
