import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/get_binding.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/widgets/circular_image.dart';
import 'package:chat_app/widgets/hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/widgets/hero_tags.dart';

class Search extends SearchDelegate {
  String selectedText;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedText),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        List<UserModel> users = controller.allUsers;
        List<UserModel> suggestionsList = [];
        query.isEmpty
            ? suggestionsList = users
            : suggestionsList.addAll(
                users.where(
                  (element) => element.name.toLowerCase().contains(query),
                ),
              );

        showSuggestions(context);
        return ListView.builder(
          itemCount: suggestionsList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  HeroWidget(
                    tag: HeroTags.imageTag(suggestionsList[index]),
                    child: CircularImage(
                      imageUrl: suggestionsList[index].imageUrl,
                      size: 60,
                    ),
                  ),
                  //online view
                  PositionedDirectional(
                    bottom: 0,
                    end: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: suggestionsList[index].isOnline
                              ? Colors.green
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        AppUtilies()
                            .getCountryByKey(suggestionsList[index].countryCode)
                            .flag,
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  )
                ],
              ),
              title: HeroWidget(
                tag: HeroTags.nameTag(suggestionsList[index]),
                child: Text(
                  suggestionsList[index].name,
                ),
              ),
              onTap: () async {
                // selectedText = suggestionsList[index].name;
                // showResults(context);
                FocusScope.of(context).unfocus();
                await Get.to(
                  () => ChatScreen(suggestionsList[index].id),
                  binding: GetBinding(),
                  duration: Duration(milliseconds: 1000),
                );
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        );
      },
    );
  }
}
