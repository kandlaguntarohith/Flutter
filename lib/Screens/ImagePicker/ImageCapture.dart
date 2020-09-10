import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallpaperapp/GeneralWidegts/ProgressIndicator.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:image/image.dart' as IM;

/// Widget to capture and crop the image
class ImageUpload extends StatefulWidget {
  final FirebaseUser user;
  const ImageUpload({Key key, this.user}) : super(key: key);
  createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  /// Active image file
  File _imageFile;
  File compressedImage;
  int height;
  int width;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: MyThemeData.accentColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        backgroundColor: MyThemeData.backGroundColor,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
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

  Future<void> _pickImage(ImageSource source) async {
    final pick = await ImagePicker().getImage(
      source: source,
    );
    File selected = File(pick.path);
    _imageFile = selected;
    compressedImage = await compressImage(selected);
    setState(() {});
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: BottomAppBar(
        color: MyThemeData.backGroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              color: Colors.blue,
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Colors.pink,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 260,
              child: Image.file(_imageFile),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: MyThemeData.accentColor,
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  color: MyThemeData.accentColor,
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Uploader(
                originalFile: _imageFile,
                compressed: compressedImage,
                user: widget.user,
                height: height,
                width: width,
              ),
            )
          ]
        ],
      ),
    );
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File originalFile;
  final File compressed;
  final int height;
  final int width;
  final FirebaseUser user;
  Uploader({
    Key key,
    this.originalFile,
    this.compressed,
    this.user,
    this.height,
    this.width,
  }) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  bool load = false;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://wallpaperapp-9acd3.appspot.com');

  StorageUploadTask _uploadTask;

  Future<void> _startUpload() async {
    setState(() {
      load = true;
    });
    final DateTime dateTime = DateTime.now();
    String filePath =
        'wallpapers/${widget.user.displayName}/compressed/$dateTime.jpeg';
    _uploadTask = _storage.ref().child(filePath).putFile(widget.compressed);
    var downLinkCompressed =
        await (await _uploadTask.onComplete).ref.getDownloadURL();
    filePath = 'wallpapers/${widget.user.displayName}/original/$dateTime.jpeg';
    setState(() {
      load = false;
    });
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.originalFile);
    });
    var downLinkOriginal =
        await (await _uploadTask.onComplete).ref.getDownloadURL();

    Navigator.of(context).pop();
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
      "height": widget.height,
      "width": widget.width,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (load == true) return BuildProgressIndicator();
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(
                        Icons.play_arrow,
                        size: 30,
                        color: MyThemeData.accentColor,
                      ),
                      onPressed: _uploadTask.resume,
                    ),
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(
                        Icons.pause,
                        size: 30,
                        color: MyThemeData.accentColor,
                      ),
                      onPressed: _uploadTask.pause,
                    ),
                  LinearProgressIndicator(value: progressPercent),
                  SizedBox(height: 10),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(0)} % ',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ]);
          });
    } else {
      return FlatButton.icon(
          color: Colors.blue,
          label: Text('Upload to Firebase'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload);
    }
  }
}
