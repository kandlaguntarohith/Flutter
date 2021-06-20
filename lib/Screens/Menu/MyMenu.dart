import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperapp/Models/Enum_HomePage.dart';
import 'package:wallpaperapp/Screens/ImagePicker/ImageCapture.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMenu extends StatefulWidget {
  MyMenu(
      {Key key,
      this.forward,
      this.showSnackBarOnHomeScreen,
      this.updateHomePageChoiceFunction})
      : super(key: key);
  final bool forward;
  final Function updateHomePageChoiceFunction;
  final Function showSnackBarOnHomeScreen;

  @override
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> with SingleTickerProviderStateMixin {
  var maxWidth, maxHeight;
  FirebaseUser currentUser;
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  Animation<Offset> _slideAnimation;
  Duration duration = Duration(milliseconds: 240);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  Future<FirebaseUser> _signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    return user;
  }

  Future<FirebaseUser> _signInWithFacebook() async {
    final facebookLoginResult = await facebookLogin.logIn(['email']);
    var credential;
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        throw ('Error Occured !');
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        throw 'Login canceled by User !';
        break;

      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        credential = FacebookAuthProvider.getCredential(
            accessToken: facebookLoginResult.accessToken.token.toString());
    }
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    return user;
  }

  Future<Null> _logOut() async {
    await _auth.signOut();
    await facebookLogin.logOut();
    await googleSignIn.signOut();
  }

  Future<void> checkLoginStatus() async {
    final user = await _auth.currentUser();
    if (user == null) return;
    currentUser = user;
  }

  @override
  void initState() {
    checkLoginStatus();
    _animationController = AnimationController(vsync: this, duration: duration);
    _slideAnimation = Tween<Offset>(begin: Offset(0.12, 0), end: Offset(0, 0))
        .animate(_animationController);
    _scaleAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    super.initState();
  }

  void didUpdateWidget(MyMenu oldWidget) {
    if (widget.forward)
      _animationController.forward();
    else
      _animationController.reverse();
    super.didUpdateWidget(oldWidget);
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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageUpload(user: currentUser)));
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
        "Upload Wallpaper ?",
        style: TextStyle(
          fontFamily: 'RobotoCondensed-Regular',
          color: (MyThemeData.backGroundColor == Colors.white) ||
                  (MyThemeData.backGroundColor == Color(0xFFEFEFEF))
              ? Colors.black
              : Colors.white,
        ),
      ),
      content: Text(
        "Wallpaper will be uploaded to Community Hub and can be seen by everyone using this app !",
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showSnackbar(String content, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: MyThemeData.backGroundColor.withOpacity(0.8),
        elevation: 4,
        content: Text(
          content,
          style: TextStyle(
            fontFamily: 'RobotoCondensed-Regular',
            color: MyThemeData.accentColor,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  showLoginOptions(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login Using ",
              style: TextStyle(
                  fontFamily: 'RobotoCondensed-Regular',
                  color: Colors.white,
                  fontSize: 14),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      try {
                        final userData = await _signInWithGoogle();
                        showSnackbar(
                            'Welcome, ' + userData.displayName, context);
                        setState(() => currentUser = userData);
                        Navigator.of(context).pop();
                      } catch (e) {
                        print(e);
                        showSnackbar('Error Occured !', context);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/images/google.png'),
                    ),
                  ),
                  SizedBox(width: 50),
                  GestureDetector(
                    onTap: () async {
                      try {
                        final userData = await _signInWithFacebook();
                        showSnackbar(
                            'Welcome, ' + userData.displayName, context);
                        setState(() => currentUser = userData);
                        Navigator.of(context).pop();
                      } catch (e) {
                        print(e);
                        if (e != 'Login canceled by User !')
                          showSnackbar('Error Occured !', context);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/images/facebook.png'),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget customIconButton(String iconName, String linkAddress) {
    return GestureDetector(
      onTap: () async {
        var url = linkAddress;
        if (await canLaunch(url)) {
          await launch(
            url,
            universalLinksOnly: true,
          );
        } else {
          throw 'There was a problem to open the url: $url';
        }
      },
      child: Container(
        height: 25,
        width: 25,
        child: Image.asset('assets/images/$iconName'),
      ),
    );
  }

  Widget customMenuButton(
      Function onPressFunction, String text, BuildContext context) {
    return FlatButton(
      onPressed: onPressFunction,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'RobotoCondensed-Regular',
          color: MyThemeData.accentColor,
          fontSize: 18,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
    return Material(
      color: MyThemeData.menuBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: maxWidth,
                height: maxHeight,
                padding: const EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyThemeData.accentColor,
                        image: DecorationImage(
                          image: currentUser == null
                              ? AssetImage(
                                  'assets/images/user.png',
                                )
                              : NetworkImage(currentUser.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    customMenuButton(
                      currentUser == null
                          ? () => showLoginOptions(context)
                          : () async {
                              await _logOut();
                              showSnackbar('Hasta la Vista', context);
                              currentUser = null;
                              setState(() {});
                            },
                      currentUser == null ? 'Sign In' : 'Sign Out',
                      context,
                    ),
                    customMenuButton(
                      () {
                        widget.updateHomePageChoiceFunction(
                            HomePage.pixelHomePage);
                      },
                      'Homepage',
                      context,
                    ),
                    customMenuButton(
                      () {
                        widget.updateHomePageChoiceFunction(
                            HomePage.developersHub);
                      },
                      'Developer Hub',
                      context,
                    ),
                    customMenuButton(
                      () {
                        widget.updateHomePageChoiceFunction(
                            HomePage.communityHub);
                      },
                      'Community Hub',
                      context,
                    ),
                    customMenuButton(
                        () => currentUser == null
                            ? showSnackbar('Please LogIn to Upload !', context)
                            : showAlertDialog(context),
                        'Upload Wallpaper',
                        context),
                    customMenuButton(() {
                      widget.updateHomePageChoiceFunction(HomePage.settings);
                    }, 'Settings', context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
