import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as IM;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class ImageUpload extends StatefulWidget {
  final FirebaseUser user;
  const ImageUpload({Key key, this.user}) : super(key: key);
  createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  int height;
  int width;
  List<Asset> images = [];
  bool load = false;
  int i = 0;

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
          quality: 80,
        );
      }),
    );
  }

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://wallpaperapp-9acd3.appspot.com');

  Future<void> _startUpload(
      File _compressed, File _originalFile, int _height, int _width) async {
    StorageUploadTask _uploadTask;
    final DateTime dateTime = DateTime.now();
    String filePath =
        'wallpapers/${widget.user.displayName}/compressed/$dateTime.jpeg';
    _uploadTask = _storage.ref().child(filePath).putFile(_compressed);
    var downLinkCompressed =
        await (await _uploadTask.onComplete).ref.getDownloadURL();
    filePath = 'wallpapers/${widget.user.displayName}/original/$dateTime.jpeg';
    _uploadTask = _storage.ref().child(filePath).putFile(_originalFile);
    var downLinkOriginal =
        await (await _uploadTask.onComplete).ref.getDownloadURL();
    await Firestore.instance
        .collection(widget.user.uid == 'jQs3Ejb6tfQSIoLT82AkiJkj0N63'
            ? 'Wallpapers'
            : 'CommunityWallpapers')
        // .collection(widget.user.uid)
        .add({
      "id": dateTime.toIso8601String(),
      "photographer": widget.user.displayName,
      "original": downLinkOriginal.toString(),
      "compressed": downLinkCompressed,
      "height": _height,
      "width": _width,
    });
  }

  void _uploadAllImagesToFirebase() async {
    setState(() {
      load = true;
    });
    for (i = 0; i < images.length; i++) {
      final path =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      final _imageFile = File(path);
      File _compressedImageFile = await compressImage(_imageFile);
      await _startUpload(_compressedImageFile, _imageFile, height, width);
      setState(() {});
    }
    Navigator.of(context).pop();
  }

  Future<File> compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Random().nextInt(10000);
    final image = IM.decodeImage(imageFile.readAsBytesSync());
    height = image.height;
    width = image.width;
    return new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(IM.encodeJpg(image, quality: 15));
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = '';
    String accentColor =
        "#${MyThemeData.accentColor.value.toRadixString(16).substring(2, 8)}";
    String backgroundColor =
        "#${MyThemeData.backGroundColor.value.toRadixString(16).substring(2, 8)}";

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: accentColor,
          statusBarColor: accentColor,
          actionBarTitle: "Wallpaper App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: accentColor,
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = ((i * 100) / images.length);
    final progressFraction = i / images.length;
    return Scaffold(
      backgroundColor: MyThemeData.backGroundColor,
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: load
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(height: 80, child: BuildProgressIndicator()),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: CircularPercentIndicator(
                      circularStrokeCap: CircularStrokeCap.round,
                      radius: 250.0,
                      lineWidth: 20.0,
                      percent: progressFraction,
                      center: Text(
                        "${progress.round()}%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.white),
                      ),
                      progressColor: MyThemeData.accentColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Uploading...',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: Colors.white),
                  )
                ],
              )
            : Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: MyThemeData.accentColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          child: Text("Pick images"),
                          onPressed: () => loadAssets(),
                        ),
                        if (images.length > 0)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: MyThemeData.accentColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            child: Text("Upload Images"),
                            onPressed: () => _uploadAllImagesToFirebase(),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: buildGridView(),
                  )
                ],
              ),
      ),
    );
  }
}
