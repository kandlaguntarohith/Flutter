import 'package:flutter/material.dart';
import 'package:wallpaperapp/Models/PixelImage.dart';
import 'package:wallpaperapp/Screens/HomeScreen/CardScrollWidget.dart';
import 'package:wallpaperapp/Screens/ImageFullScreen/ImageFullScreen.dart';

class ImageSwiper2 extends StatefulWidget {
  final List<PixelImage> images;

  const ImageSwiper2({Key key, this.images}) : super(key: key);
  @override
  _ImageSwiper2State createState() => _ImageSwiper2State();
}

class _ImageSwiper2State extends State<ImageSwiper2> {
  var currentPage;
  @override
  void initState() {
    currentPage = widget.images.length - 1.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller =
        PageController(initialPage: widget.images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return Stack(
      children: <Widget>[
        CardScrollWidget(currentPage, widget.images),
        Positioned.fill(
          child: PageView.builder(
            // physics: BouncingScrollPhysics(),
            physics: ClampingScrollPhysics(),
            itemCount: widget.images.length,
            controller: controller,
            reverse: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ImageFullScreen(
                      image: widget.images[index],
                    ),
                    opaque: false,
                  ),
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
