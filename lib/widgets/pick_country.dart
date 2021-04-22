// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
// import 'package:chat_app/helper/Utilies.dart';
//
// class PickCountry extends StatefulWidget {
//   final Function(CountryModel countryModel) builder;
//
//   PickCountry({this.builder});
//
//   @override
//   _PickCountryState createState() => _PickCountryState();
// }
//
// class _PickCountryState extends State<PickCountry> {
//   final _searchController = FloatingSearchBarController();
//   List<CountryModel> countriesList = [];
//   List<CountryModel> tempList = [];
//   bool loading = false;
//
//   getCountries(BuildContext context) async {
//     setState(() {
//       loading = true;
//     });
//
//     countriesList = AppUtilies.countries.entries
//         .map((e) => CountryModel(
//             name: e.value.toString(),
//             code: e.key,
//             flag: 'src/images/flags/${e.key.toLowerCase()}.png'))
//         .toList();
//     _searchController.open();
//     setState(() {
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       if (countriesList.isEmpty) getCountries(context);
//     });
//
//     return Scaffold(
//       body: FloatingSearchBar(
//         hint: 'Find your country',
//         scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
//         transitionDuration: const Duration(milliseconds: 800),
//         transitionCurve: Curves.easeInOut,
//         physics: const BouncingScrollPhysics(),
//         axisAlignment: isPortrait ? 0.0 : -1.0,
//         openAxisAlignment: 0.0,
//         width: isPortrait ? 600 : 500,
//         debounceDelay: const Duration(milliseconds: 500),
//         clearQueryOnClose: false,
//         onFocusChanged: (isFocused) {
//           if (countriesList.isNotEmpty)
//             search(_searchController.query);
//           else {
//             Fluttertoast.showToast(msg: 'Loading Data');
//             getCountries(context);
//           }
//         },
//         body: Center(
//           child: Text('Type your country country name'),
//         ),
//         onQueryChanged: (query) {
//           if (countriesList.isNotEmpty)
//             search(query);
//           else {
//             Fluttertoast.showToast(msg: 'Loading Data');
//             getCountries(context);
//           }
//         },
//         // Specify a custom transition to be used for
//         // animating between opened and closed stated.
//         transition: CircularFloatingSearchBarTransition(),
//         actions: [
//           FloatingSearchBarAction.searchToClear(
//             showIfClosed: false,
//           ),
//         ],
//         controller: _searchController,
//         builder: (context, transition) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Material(
//               color: Colors.white,
//               elevation: 4.0,
//               child: loading
//                   ? Center(
//                       child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Container(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.0,
//                         ),
//                       ),
//                     ))
//                   : Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: tempList
//                           .map(
//                             (country) => Padding(
//                               padding: const EdgeInsets.all(10),
//                               child: InkWell(
//                                 onTap: () {
//                                   widget.builder(country);
//                                   Get.back();
//                                 },
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: <Widget>[
//                                     Image.asset(country.flag),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Expanded(
//                                         child: Text(
//                                       country.name,
//                                       maxLines: 2,
//                                       style:
//                                           Theme.of(context).textTheme.bodyText1,
//                                     )),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                     ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void search(String query) {
//     setState(() {
//       loading = true;
//     });
//     tempList.clear();
//     if (query.isNotEmpty) {
//       tempList.addAll(countriesList.where((element) =>
//           element.name.toLowerCase().contains(query.toLowerCase())));
//     } else {
//       tempList.addAll(countriesList);
//     }
//     setState(() {
//       loading = false;
//     });
//   }
// }
//
