import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class OnlineImagesViewer extends StatelessWidget {
  final int initialIndex;
  final List<String> images;

  OnlineImagesViewer({@required this.initialIndex, @required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //make body under appbar
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: Text(
          'Jone',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: () {
              //download image
            },
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: CarouselSlider(
        items: createSliders(),
        options: CarouselOptions(
          autoPlay: false,
          height: double.infinity,
          viewportFraction: 1,
          aspectRatio: 1,
          enableInfiniteScroll: images.length > 1,
          initialPage: initialIndex,
          enlargeCenterPage: true,
          autoPlayAnimationDuration: Duration(seconds: 2),
        ),
      ),
    );
  }

  List<Widget> createSliders() {
    return images
        .map(
          (item) => ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: PhotoView(
              imageProvider: NetworkImage(item),
            ),
          ),
        )
        .toList();
  }
}
