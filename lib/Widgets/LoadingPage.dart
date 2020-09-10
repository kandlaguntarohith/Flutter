import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  var height = 80;
  List colors = [
    Colors.red[900],
    Colors.pink[900],
    Colors.deepOrange[900],
    Colors.purple[900],
    Colors.blue[900],
    Colors.green[900],
  ];
  Random random = new Random();

  double changeHeight() {
    height = height == 80 ? 30 : 80;
    return height.toDouble();
  }

  int index = 0;

  void changeIndex() {
    index = random.nextInt(colors.length);
  }

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      changeIndex();
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
            duration: Duration(milliseconds: 300),
            height: changeHeight(),
            width: 20,
            color: colors[index],
            curve: Curves.linear,
            child: Container(),
          ),
          SizedBox(
            width: 10,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: changeHeight(),
            width: 20,
            color: colors[index],
            curve: Curves.linear,
          ),
          SizedBox(
            width: 10,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: changeHeight(),
            width: 20,
            color: colors[index],
            curve: Curves.linear,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
