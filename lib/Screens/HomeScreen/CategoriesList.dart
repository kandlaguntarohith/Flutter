import 'package:flutter/material.dart';
import 'package:wallpaperapp/DATA/CategoriesData.dart';
import 'package:wallpaperapp/Models/CategorieModel.dart';
import 'package:wallpaperapp/Screens/HomeScreen/CategoryListTile.dart';

class CategoriesList extends StatefulWidget {
  final String selectedCategorie;
  final Function updateCategorieFunction;

  const CategoriesList(
      {Key key, this.selectedCategorie, this.updateCategorieFunction})
      : super(key: key);
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List<CategorieModel> categotries;
  @override
  void initState() {
    categotries = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 40,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () =>
              widget.updateCategorieFunction(categotries[index].categorieName),
          child: CategoriesListTile(
            category: categotries[index],
            isSelected:
                widget.selectedCategorie == categotries[index].categorieName,
          ),
        ),
        itemCount: getCategories().length,
      ),
    );
  }
}
