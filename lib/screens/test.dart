import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Test extends StatelessWidget {
  final List<DropdownMenuItem> items = [];

  final List<String> data = [
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
  ];

  @override
  Widget build(BuildContext context) {
    items.addAll(
      data.map(
        (e) => DropdownMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Image.asset(e.flag),
              // SizedBox(
              //   width: 10,
              // ),
              Expanded(
                  child: Text(
                e,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyText1,
              )),
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      body: Container(
        alignment: AlignmentDirectional.center,
        height: 800,
        child: Center(
          child: SearchableDropdown.multiple(
            items: items,
            // value: null,
            hint: "Select one",
            searchHint: "Select one",
            onChanged: (value) {
              print(value);
            },
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
