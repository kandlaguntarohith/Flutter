import 'package:flutter/material.dart';
import 'package:wallpaperapp/Bloc/PixelImageBloc.dart';
import 'package:wallpaperapp/Models/Enum_HomePage.dart';
import 'package:wallpaperapp/Models/PixelImage.dart';
import 'package:wallpaperapp/Response/PixelImageReponse.dart';
import 'package:wallpaperapp/Screens/HubSpace/HubSpace.dart';
import 'package:wallpaperapp/Screens/Menu/MyMenu.dart';
import 'package:wallpaperapp/Screens/Search/SearchScreen.dart';
import 'package:wallpaperapp/Screens/Settings/Settings.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart' as theme;
import 'SliverHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomePage homepage = HomePage.pixelHomePage;
  bool isCollapsed;
  var maxWidth;
  var maxHeight;
  var radius;
  final pixelImageBloc = PixelImageBloc();
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  Animation<Offset> _slideAnimation;

  Duration duration = Duration(milliseconds: 220);
  String selectedCategorie;
  int page;
  bool update;
  bool forward;
  // ignore: non_constant_identifier_names
  int per_page;
  var maxImagesCount;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.42, 0.02))
            .animate(_animationController);
    _scaleAnimation =
        Tween<double>(begin: 1, end: 0.75).animate(_animationController);
    isCollapsed = false;
    selectedCategorie = 'Trending';
    page = 1;
    per_page = 50;
    pixelImageBloc.getCuratedImages(page, per_page);
    forward = false;
  }

  updateThemeData(Color mainBackgroundColor, Color accentColor,
      Color menuBackgroundColor) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setInt('backGroundColor',
        theme.mainBackgroundColors.indexOf(mainBackgroundColor));
    await _pref.setInt('accentColor', theme.accentColor.indexOf(accentColor));
    await _pref.setInt(
        'menuBackgroundColor', theme.menuColor.indexOf(menuBackgroundColor));
    setState(() {
      theme.MyThemeData.backGroundColor = mainBackgroundColor;
      theme.MyThemeData.accentColor = accentColor;
      theme.MyThemeData.menuBackgroundColor = menuBackgroundColor;
    });
  }

  void updateCategorie(String cat) {
    if (selectedCategorie == cat) return;
    pixelImageBloc.drain();
    selectedCategorie = cat;
    page = 1;
    if (selectedCategorie != 'Trending')
      pixelImageBloc.getSearchImages(page, per_page, selectedCategorie);
    else
      pixelImageBloc.getCuratedImages(page, per_page);
  }

  void addMore() {
    if (selectedCategorie != 'Trending')
      pixelImageBloc.getSearchImages(++page, per_page, selectedCategorie);
    else
      pixelImageBloc.getCuratedImages(++page, per_page);
  }

  void showCustomSnackbar(String showString) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          showString,
          style: TextStyle(
            fontFamily: 'RobotoCondensed-Regular',
            color: theme.MyThemeData.accentColor,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget getBodyWidget(HomePage homePage) {
    if (homePage == HomePage.developersHub)
      return HubSpace(
        collectionName: 'Wallpapers',
        key: Key('1'),
      );
    else if (homePage == HomePage.communityHub)
      return HubSpace(
        collectionName: 'CommunityWallpapers',
        key: Key("2"),
      );
    else if (homePage == HomePage.settings)
      return Settings(
        updateThemeData: updateThemeData,
      );
    return StreamBuilder<PixelImageResponse>(
      stream: pixelImageBloc.subject.stream,
      builder: (context, snapshot) {
        bool error = false;
        bool isLoading = false;
        List<PixelImage> data;
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0)
            error = true;
          else {
            data = snapshot.data.images.length == 0 ? [] : snapshot.data.images;
            maxImagesCount = snapshot.data.maxCount;
          }
        } else if (snapshot.hasError)
          error = true;
        else
          isLoading = true;
        return SliverHome(
          images: data,
          error: error,
          isLoading: isLoading,
          selectedCategorie: selectedCategorie,
          updateCategorieFunction: updateCategorie,
          addMore: addMore,
        );
      },
    );
  }

  void updateHomePageChoice(HomePage homePage) {
    setState(() {
      isCollapsed = false;
      forward = false;
      _animationController.reverse();
      homepage = homePage;
    });
  }

  @override
  void dispose() {
    // pixelImageBloc.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    radius = MediaQuery.of(context).systemGestureInsets;
    final size = MediaQuery.of(context).size;
    maxHeight = size.height;
    maxWidth = size.width;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => widget.updateTheme(Colors.purple),
      //   child: Icon(Icons.add),
      // ),
      backgroundColor: theme.MyThemeData.menuBackgroundColor,
      body: Stack(
        children: [
          MyMenu(
            forward: forward,
            showSnackBarOnHomeScreen: showCustomSnackbar,
            updateHomePageChoiceFunction: updateHomePageChoice,
          ),
          SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedContainer(
                duration: duration,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(isCollapsed ? 30 : 0),
                    ),
                    color: theme.MyThemeData.backGroundColor),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(isCollapsed ? 30 : 0)),
                  child: Scaffold(
                    backgroundColor: theme.MyThemeData.backGroundColor,
                    appBar: AppBar(
                      elevation: 0,
                      leading: IconButton(
                          icon: Icon(
                            isCollapsed ? Icons.arrow_back : Icons.menu,
                            size: isCollapsed ? 50 : 25,
                            color: theme.MyThemeData.accentColor,
                          ),
                          onPressed: () {
                            isCollapsed = !isCollapsed;
                            setState(() {
                              if (isCollapsed)
                                forward = true;
                              else
                                forward = false;
                            });
                            // update = false;
                            if (isCollapsed)
                              _animationController.forward();
                            else
                              _animationController.reverse();
                          }),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            homepage == HomePage.pixelHomePage
                                ? 'Wallpaper'
                                : homepage == HomePage.developersHub
                                    ? 'Developer'
                                    : homepage == HomePage.settings
                                        ? 'Settings'
                                        : 'Community',
                            style: TextStyle(
                              fontFamily: "Lobster-Regular",
                              color: (theme.MyThemeData.backGroundColor ==
                                          Colors.white) ||
                                      (theme.MyThemeData.backGroundColor ==
                                          Color(0xFFEFEFEF))
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            homepage == HomePage.pixelHomePage ? 'App' : 'Hub',
                            style: TextStyle(
                                color: theme.MyThemeData.accentColor,
                                fontFamily: "Lobster-Regular"),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      actions: <Widget>[
                        homepage == HomePage.pixelHomePage
                            ? IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: theme.MyThemeData.accentColor,
                                ),
                                onPressed: () =>
                                    Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      SearchScreen(),
                                  opaque: false,
                                )),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width / 6),
                      ],
                    ),
                    body: getBodyWidget(homepage),
                    // body:
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
