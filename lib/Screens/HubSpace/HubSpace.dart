import 'package:flutter/material.dart';
import 'package:wallpaperapp/GeneralWidegts/ProgressIndicator.dart';
import 'package:wallpaperapp/Models/FirebaseImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaperapp/Screens/HomeScreen/BodyImages.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';

class HubSpace extends StatefulWidget {
  final String collectionName;

  const HubSpace({Key key, this.collectionName}) : super(key: key);
  @override
  _DevelopersHubState createState() => _DevelopersHubState();
}

class _DevelopersHubState extends State<HubSpace> {
  CollectionReference collectionReference;
  ScrollController _controller;
  int count;
  bool load;
  List<FirebaseImage> images = [];
  void addMore() {
    if (images.length == count) return;
    if (images.length > count) {
      if ((images.length - count) < 6) {
        count = images.length;
        load = false;
      } else
        count = count + 6;
    }
    setState(() {});
  }

  @override
  void initState() {
    collectionReference = Firestore.instance.collection(widget.collectionName);
    collectionReference.snapshots().listen((dataSnapshot) {
      List<FirebaseImage> img = [];
      dataSnapshot.documents.toList().forEach((element) {
        img.add(FirebaseImage.fromJson(element.data));
      });
      count = img.length <= 10 ? img.length : 10;
      load = img.length == count ? false : true;
      setState(() {
        images = img;
      });
    });
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.pixels ==
                _controller.position.maxScrollExtent &&
            _controller.position.pixels != 0) addMore();
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: images.length == 0
          ? BuildProgressIndicator()
          : ListView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                BodyImages(
                  images: images,
                  count: count,
                ),
                Container(
                  height: 80,
                  child: load
                      ? BuildProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "All Caught Up !",
                            style: TextStyle(
                              color: MyThemeData.backGroundColor ==
                                      Colors.grey[900]
                                  ? Colors.grey
                                  : Colors.grey[900],
                              fontSize: 15,
                              fontFamily: 'RobotoCondensed-Regular',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                )
              ],
            ),
    );
  }
}
