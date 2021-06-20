import 'package:flutter/material.dart';
import 'package:wallpaperapp/Models/CategorieModel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaperapp/ThemeData/ThemeData.dart';

class CategoriesListTile extends StatelessWidget {
  final CategorieModel category;
  final bool isSelected;
  const CategoriesListTile({Key key, this.category, this.isSelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? null : Colors.grey[900],
                borderRadius: const BorderRadius.all(
                  const Radius.circular(5),
                ),
                image: DecorationImage(
                  image: AssetImage(category.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? MyThemeData.accentColor
                    : Colors.black.withOpacity(0.25),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: isSelected
                  ? Shimmer.fromColors(
                      child: Text(
                        category.categorieName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          // fontFamily: "PermanentMarker-Regular",
                        ),
                      ),
                      baseColor: Colors.white,
                      highlightColor: Colors.redAccent[100],
                    )
                  : Text(
                      category.categorieName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        fontFamily: "RobotoCondensed-Regular",
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
