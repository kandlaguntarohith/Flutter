import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperapp/Screens/ImageFullScreen/ImageFullScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BodyImages extends StatefulWidget {
  final images;
  final count;

  const BodyImages({Key key, this.images, this.count}) : super(key: key);
  @override
  _BodyImagesState createState() => _BodyImagesState();
}

class _BodyImagesState extends State<BodyImages> {
  var maxItemLogicalLength;
  @override
  Widget build(BuildContext context) {
    maxItemLogicalLength = (MediaQuery.of(context).size.width - 30) / 2;
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: widget.count??widget.images.length,
      itemBuilder: (BuildContext context, int index) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ImageFullScreen(
                image: widget.images[index],
              ),
              opaque: false,
            ),
          ),
          child: Hero(
            tag: widget.images[index].id,
            child: Container(
              height: (widget.images[index].height * maxItemLogicalLength) /
                  widget.images[index].width,
              child: CachedNetworkImage(
                placeholder: (context, url) => Image.asset(
                  'assets/images/PlaceHolderImage.jpg',
                  fit: BoxFit.cover,
                ),
                imageUrl: widget.images[index].compressedOriginal,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    );
  }
}
