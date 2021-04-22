import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/data/country_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Center(
        child: DropdownButton<CountryModel>(
          iconSize: 30,
          itemHeight: 50,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          onChanged: (CountryModel countryModel) {
            controller.selectCountry(countryModel);
          },
          value: controller.selectedCountry,
          items: controller.countries
              .map<DropdownMenuItem<CountryModel>>(
                (country) => DropdownMenuItem<CountryModel>(
                  value: country,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      country.flag,
                      width: 40,
                      height: 30,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
