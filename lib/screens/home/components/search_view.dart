import 'package:chat_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/home/components/search.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => InkWell(
        onTap: () {
          showSearch(
              context: context,
              delegate: Search());
        },
        child: Container(
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Card(
              elevation: 3,
              shadowColor: Colors.black,
              child: new ListTile(
                trailing: new Icon(Icons.search),
                title: Text(
                  'search...',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
