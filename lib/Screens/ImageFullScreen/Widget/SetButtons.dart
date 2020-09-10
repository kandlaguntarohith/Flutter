import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wallpaperapp/GeneralWidegts/ProgressIndicator.dart';
import 'package:wallpaperapp/Models/FirebaseImage.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:gallery_saver/files.dart';

class SetButtons extends StatelessWidget {
  final image;

  const SetButtons({Key key, this.image}) : super(key: key);

  _askPermission() async {
    final permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted)
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    print(permission);
  }

  _save(BuildContext context) async {
    await _askPermission();
    var response = await Dio().get(image.original.toString(),
        options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
        quality: 100, name: image.id.toString());
    Navigator.of(context).pop();
  }

  // _save(BuildContext context) async {
  //   _askPermission();
  //   String path = image.original;
  //   print(path);

  //   await GallerySaver.saveImage(path, albumName: image.id.toString());
  //   Navigator.of(context).pop();
  // }

  Future<Null> _setAsDeviceLockScreenWallapaper(BuildContext context) async {
    String url =
        image.runtimeType == FirebaseImage ? image.original : image.portrait;
    final file = await DefaultCacheManager().getSingleFile(url);
    await WallpaperManager.setWallpaperFromFile(
        file.path, WallpaperManager.LOCK_SCREEN);
  }

  Future<Null> _setAsDeviceHomeScreenWallapaper(BuildContext context) async {
    final file = await DefaultCacheManager().getSingleFile(image.original);
    await WallpaperManager.setWallpaperFromFile(
        file.path, WallpaperManager.HOME_SCREEN);
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(
          fontFamily: 'RobotoCondensed-Regular',
          color: MyThemeData.accentColor,
          // fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        showLoadDialog(context);
        _save(context);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          fontFamily: 'RobotoCondensed-Regular',
          color: MyThemeData.accentColor,
          // fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: MyThemeData.backGroundColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      title: Text(
        "Download Wallpaper ?",
        style: TextStyle(
          fontFamily: 'RobotoCondensed-Regular',
          color: (MyThemeData.backGroundColor == Colors.white) ||
                  (MyThemeData.backGroundColor == Color(0xFFEFEFEF))
              ? Colors.black
              : Colors.white,
        ),
      ),
      content: Text(
        "This will download the orginal image to the gallery !",
        style: TextStyle(
          fontFamily: 'RobotoCondensed-Regular',
          color: (MyThemeData.backGroundColor == Colors.white) ||
                  (MyThemeData.backGroundColor == Color(0xFFEFEFEF))
              ? Colors.black
              : Colors.white,
        ),
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: alert,
        );
      },
    );
  }

  showLoadDialog(BuildContext context) {
    final alert = Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: MyThemeData.backGroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        child: Container(
          height: 50,
          width: 50,
          child: BuildProgressIndicator(),
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: alert,
        );
      },
    );
  }

  Widget wallpaperSetButtons(String text, Function onPressed) {
    return Center(
      child: Container(
        width: 250,
        height: 50,
        child: RaisedButton(
            color: MyThemeData.accentColor,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'RobotoCondensed-Regular',
                color: (MyThemeData.backGroundColor == Colors.white) ||
                        (MyThemeData.backGroundColor == Color(0xFFEFEFEF))
                    ? Colors.black
                    : Colors.white,
                // fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed),
      ),
    );
  }

  showAlertDialogToSetAsWallaper(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: MyThemeData.backGroundColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      title: Text(
        "Set as",
        style: TextStyle(
          fontFamily: 'RobotoCondensed-Regular',
          color: (MyThemeData.backGroundColor == Colors.white) ||
                  (MyThemeData.backGroundColor == Color(0xFFEFEFEF))
              ? Colors.black
              : Colors.white,
        ),
      ),
      scrollable: true,
      actions: [
        SizedBox(height: 20),
        wallpaperSetButtons(
          "LockScreen",
          () async {
            Navigator.of(context).pop();
            // showLoadDialog(context);
            await Future.delayed(const Duration(microseconds: 2), () {
              _setAsDeviceLockScreenWallapaper(context);
              // Navigator.of(context).pop();
            });
          },
        ),
        SizedBox(height: 20),
        wallpaperSetButtons(
          'HomeScreen',
          () async {
            Navigator.of(context).pop();
            // showLoadDialog(context);
            await Future.delayed(const Duration(microseconds: 2), () async {
              await _setAsDeviceHomeScreenWallapaper(context);
              // Navigator.of(context).pop();
            });
          },
        ),
        SizedBox(height: 20),
        wallpaperSetButtons(
          'Both',
          () async {
            Navigator.of(context).pop();
            // showLoadDialog(context);
            await Future.delayed(const Duration(microseconds: 2), () async {
              await _setAsDeviceLockScreenWallapaper(context);
              await _setAsDeviceHomeScreenWallapaper(context);
              // Navigator.of(context).pop();
            });
          },
        ),
        SizedBox(height: 30),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: MyThemeData.accentColor,
              size: 35,
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: alert,
        );
      },
    );
  }

  Widget customButton(
    String text,
    Function onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: MyThemeData.accentColor.withOpacity(0.9),
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        alignment: Alignment.center,
        height: 50,
        width: 230,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'RobotoCondensed-Regular',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 150,
          child: Column(
            children: <Widget>[
              customButton(
                  'Download to Gallery', () => showAlertDialog(context)),
              SizedBox(height: 20),
              customButton('Set as Wallpaper',
                  () => showAlertDialogToSetAsWallaper(context)),
            ],
          ),
        ),
      ),
    );
  }
}
