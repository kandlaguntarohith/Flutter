import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaperapp/Screens/HomeScreen/HomeScreen.dart';
import 'ThemeData/ThemeData.dart' as theme;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);
  _getStoredThemeData(BuildContext context) async {
    // getCategories().forEach((element) {
    //   precacheImage(NetworkImage(element.imgUrl), context);
    // });
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    // setState(() {
    theme.MyThemeData.backGroundColor =
        theme.mainBackgroundColors[_pref.getInt('backGroundColor') ?? 0];
    theme.MyThemeData.accentColor =
        theme.accentColor[_pref.getInt('accentColor') ?? 0];
    theme.MyThemeData.menuBackgroundColor =
        theme.menuColor[_pref.getInt('menuBackgroundColor') ?? 0];
    // });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: theme.MyThemeData.accentColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: _getStoredThemeData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: SizedBox(
                    height: 100, child: Image.asset('assets/images/icon.png')),
              );
            return HomeScreen();
          },
        ));
  }
}
