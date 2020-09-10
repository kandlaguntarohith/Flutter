import 'package:flutter/material.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';

class Settings extends StatelessWidget {
  final Function updateThemeData;

  Widget getColorPalette(List<Color> colors, String text) {
    Color borderColor(Color color) {
      if (text == 'Accent Color')
        return color == MyThemeData.accentColor
            ? Colors.black
            : Colors.transparent;
      else if (text == 'Background Color')
        return color == MyThemeData.backGroundColor
            ? MyThemeData.accentColor
            : Colors.black;
      else
        return color == MyThemeData.menuBackgroundColor
            ? MyThemeData.accentColor
            : Colors.black;
    }

    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(height: 20),
        Text(
          text,
          style: TextStyle(
            color: (MyThemeData.backGroundColor == Colors.white)||(MyThemeData.backGroundColor == Color(0xFFEFEFEF))
                ? Colors.black
                : Colors.white,
              
            fontSize: 18,
            fontFamily: 'RobotoCondensed-Regular',
            
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              primary: false,
              crossAxisCount: 5,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              shrinkWrap: true,
              children: colors
                  .map(
                    (color) => GestureDetector(
                      onTap: () {
                        if (text == 'Background Color')
                          updateThemeData(color, MyThemeData.accentColor,
                              MyThemeData.menuBackgroundColor);
                        else if (text == 'Accent Color')
                          updateThemeData(MyThemeData.backGroundColor, color,
                              MyThemeData.menuBackgroundColor);
                        else
                          updateThemeData(MyThemeData.backGroundColor,
                              MyThemeData.accentColor, color);
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: borderColor(color),
                                width: 5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              color: color),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        )
      ],
    );
  }

  Settings({Key key, this.updateThemeData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          getColorPalette(mainBackgroundColors, 'Background Color'),
          getColorPalette(accentColor, 'Accent Color'),
          getColorPalette(menuColor, 'Menu  Color'),
        ],
      ),
    );
  }
}
