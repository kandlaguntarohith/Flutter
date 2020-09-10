import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';

class BuildProgressIndicator extends StatefulWidget {
  @override
  _BuildProgressIndicatorState createState() => _BuildProgressIndicatorState();
}

class _BuildProgressIndicatorState extends State<BuildProgressIndicator> {
  var height;
  double changeHeight() {
    height = height == 60 ? 25 : 60;
    return height.toDouble();
  }

  Timer timer;

  @override
  void initState() {
    height = 60;
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: MyThemeData.accentColor,
            ),
            duration: Duration(milliseconds: 300),
            height: changeHeight(),
            width: 8,
            curve: Curves.linear,
            child: Container(),
          ),
          SizedBox(
            width: 8,
          ),
          AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: MyThemeData.accentColor,
            ),
            duration: Duration(milliseconds: 300),
            height: changeHeight(),
            width: 8,
            curve: Curves.linear,
          ),
          SizedBox(
            width: 8,
          ),
          AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: MyThemeData.accentColor,
            ),
            duration: Duration(milliseconds: 300),
            height: changeHeight(),
            width: 8,
            curve: Curves.linear,
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
