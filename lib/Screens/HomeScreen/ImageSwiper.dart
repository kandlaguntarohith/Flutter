import 'package:flutter/material.dart';
import 'package:wallpaperapp/Models/PixelImage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageSwiper extends StatefulWidget {
  final List<PixelImage> images;

  const ImageSwiper({Key key, this.images}) : super(key: key);
  @override
  _ImageSwiperState createState() => _ImageSwiperState();
}

class _ImageSwiperState extends State<ImageSwiper> {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Image.network(
            widget.images[index].portrait,
            fit: BoxFit.fill,
          ),
        );
      },
      itemCount: widget.images.length,
      itemWidth: 200.0,
      itemHeight: 280.0,
      layout: SwiperLayout.STACK,
      autoplay: true,
      // containerWidth: 500,
      // curve: Curves.fastLinearToSlowEaseIn,
      // fade: 5,
    );
  }
}
