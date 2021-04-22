import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/static_values.dart';
import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  CircularImage({@required this.imageUrl, @required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        width: size,
        height: size,
        fit: BoxFit.cover,
        imageUrl: imageUrl,
        placeholder: (context, url) => Image.asset(
          'src/images/placeholder.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
