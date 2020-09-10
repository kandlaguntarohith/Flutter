import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaperapp/Screens/ImageFullScreen/Widget/SetButtons.dart';

class ImageFullScreen extends StatelessWidget {
  final image;

  ImageFullScreen({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Hero(
      tag: image.id,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: <Widget>[
             Container(
              height: height,
              width: width,
              child: CachedNetworkImage(
                imageUrl: image.compressedOriginal,
                fit: BoxFit.cover,
              ),
              // fit: BoxFit.cover,
            ),
              Container(
                height: height,
                width: width,
                child: CachedNetworkImage(
                  imageUrl: image.original,
                  fit: BoxFit.cover,
                ),
                // fit: BoxFit.cover,
              ),
            SetButtons(
              image: image,
            ),
          ],
        ),
      ),
    );
  }
}
