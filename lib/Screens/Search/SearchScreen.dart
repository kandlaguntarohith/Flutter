import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallpaperapp/Bloc/PixelImageBloc.dart';
import 'package:wallpaperapp/GeneralWidegts/ErrorDisplayWidget.dart';
import 'package:wallpaperapp/GeneralWidegts/ProgressIndicator.dart';
import 'package:wallpaperapp/Response/PixelImageReponse.dart';
import 'package:wallpaperapp/Screens/HomeScreen/BodyImages.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller;
  ScrollController scrollController;
  bool _load = false;
  int pageNo;
  // ignore: non_constant_identifier_names
  int per_page;
  var searchImageFeed = PixelImageBloc();
  String previousQuery;
  @override
  void initState() {
    per_page = 50;
    previousQuery = '';
    pageNo = 1;
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            scrollController.position.pixels != 0) {
          loadMoreData();
        }
      });
    _controller = TextEditingController()
      ..addListener(() {
        final query = _controller.text.trim();
        if (query.length > 0 && previousQuery != query) {
          previousQuery = query;
          setState(() {
            _load = true;
          });
          searchImageFeed.drain();
          searchImageFeed.getSearchImages(pageNo, per_page, _controller.text);
        } else if (previousQuery != query || query == null) {
          print('herer');
          searchImageFeed.drain();
          setState(() {
            _load = false;
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    searchImageFeed.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void loadMoreData() {
    searchImageFeed.getSearchImages(++pageNo, per_page, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyThemeData.accentColor,
          ),
          centerTitle: true,
          flexibleSpace: Container(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          title: TextField(
            cursorColor: MyThemeData.accentColor,
            autofocus: true,
            controller: _controller,
            style: TextStyle(
              height: 1.5,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.search,
                color: MyThemeData.accentColor,
              ),
              hintText: '  Search wallapapers',
              hintStyle: TextStyle(
                fontFamily: 'RobotoCondensed-Regular',
                color: Colors.grey,
              ),
              // alignLabelWithHint: false,
            ),
          ),
        ),
        body: StreamBuilder<PixelImageResponse>(
          stream: searchImageFeed.subject.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && _controller.text.trim() != '') {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return BuildErrorDisplayWidget(error: snapshot.data.error);
              } else {
                return (snapshot.data.images.length > 0)
                    ? SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: BodyImages(images: snapshot.data.images),
                            ),
                            Container(
                              height: 200,
                              child: snapshot.data.maxCount == null
                                  ? BuildProgressIndicator()
                                  : (snapshot.data.maxCount >
                                          snapshot.data.images.length)
                                      ? BuildProgressIndicator()
                                      : Center(
                                          child: Text(
                                            'All Caught Up !',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: MyThemeData.accentColor,
                          child: Text(
                            'TrY a BeTtEr KeYwOrD !',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensed-Regular',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
              }
            } else if (snapshot.hasError)
              return BuildErrorDisplayWidget(error: snapshot.error);
            if (_controller.text.trim() == '') _load = false;
            return _load
                ? BuildProgressIndicator()
                : Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: MyThemeData.accentColor,
                      child: Text(
                        'Search a Keyword',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed-Regular',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
