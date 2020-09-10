import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallpaperapp/GeneralWidegts/ErrorDisplayWidget.dart';
import 'package:wallpaperapp/GeneralWidegts/ProgressIndicator.dart';
import 'package:wallpaperapp/Models/PixelImage.dart';
import 'package:wallpaperapp/Screens/HomeScreen/BodyImages.dart';
import 'package:wallpaperapp/Screens/HomeScreen/CategoriesList.dart';
import 'package:wallpaperapp/Screens/HomeScreen/ImageSwiper2.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: 56.0,
      child: Card(
        margin: EdgeInsets.all(0),
        color: MyThemeData.backGroundColor,
        elevation: 0,
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class SliverHome extends StatefulWidget {
  final List<PixelImage> images;
  final bool error;
  final bool isLoading;
  final String selectedCategorie;
  final Function updateCategorieFunction;
  final Function addMore;
  final int maxImagesCount;
  const SliverHome(
      {Key key,
      this.images,
      this.error,
      this.isLoading,
      this.selectedCategorie,
      this.updateCategorieFunction,
      this.addMore,
      this.maxImagesCount})
      : super(key: key);

  @override
  _SliverHomeState createState() => _SliverHomeState();
}

class _SliverHomeState extends State<SliverHome> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.pixels ==
                _controller.position.maxScrollExtent &&
            _controller.position.pixels != 0) widget.addMore();
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomScrollView(
        controller: _controller,
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 360,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: widget.error
                        ? BuildErrorDisplayWidget(error: 'Error Occured')
                        : widget.isLoading
                            ? BuildProgressIndicator()
                            : ImageSwiper2(
                                images: widget.images.sublist(0, 10)),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: PersistentHeader(
              widget: CategoriesList(
                selectedCategorie: widget.selectedCategorie,
                updateCategorieFunction: widget.updateCategorieFunction,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: widget.error
                        ? BuildErrorDisplayWidget(error: 'Error Occured')
                        : widget.isLoading
                            ? Container(height: 80)
                            : BodyImages(
                                images: [...widget.images]..removeRange(0, 10),
                              ),
                  ),
                  // if (widget.isLoading)
                  Container(height: 100, child: BuildProgressIndicator()),
                ],
              ),
            ),
          ),
        ],
      ),
      if (widget.isLoading)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Center(
            child: BuildProgressIndicator(),
          ),
        ),
    ]);
    // },
    // );
  }
}
