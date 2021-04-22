import 'package:chat_app/controllers/register_controller.dart';
import 'package:chat_app/data/country_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class RegisterCountriesMenu extends StatefulWidget {
  @override
  _RegisterCountriesMenuState createState() => _RegisterCountriesMenuState();
}

class _RegisterCountriesMenuState extends State<RegisterCountriesMenu> {
  final List<DropdownMenuItem> items = [];
  CountryModel selected;

  @override
  void initState() {
    super.initState();
    items.addAll(
      Get.find<RegisterController>().countries.map(
            (e) => DropdownMenuItem(
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SearchableDropdown.single(
        items: items,
        value: selected,
        hint: "Select your country",
        searchHint: "Search for your country",
        onChanged: (value) {
          print(value);
          setState(() {
            selected = value as CountryModel;
          });
          Get.find<RegisterController>().addUserCountry(selected);
        },
        isExpanded: true,
      ),
    );
  }
}
