import 'package:wallpaperapp/Models/CategorieModel.dart';

List<CategorieModel> getCategories() {
  List<CategorieModel> categories = List();
  CategorieModel categorieModel = CategorieModel();
  categorieModel.path = 'assets/images/trending.jpg';
  categorieModel.categorieName = "Trending";
  categories.add(categorieModel);
  categorieModel = CategorieModel();

  categorieModel.path = "assets/images/streetart.jpg";
  categorieModel.categorieName = "Street Art";
  categories.add(categorieModel);
  categorieModel = CategorieModel();

  categorieModel.path = "assets/images/wildlife.jpg";
  categorieModel.categorieName = "Wild Life";
  categories.add(categorieModel);
  categorieModel = CategorieModel();

  categorieModel.path = "assets/images/nature.jpg";
  categorieModel.categorieName = "Nature";
  categories.add(categorieModel);
  categorieModel = CategorieModel();

  categorieModel.path = "assets/images/city.jpg";
  categorieModel.categorieName = "City";
  categories.add(categorieModel);
  categorieModel = CategorieModel();

  categorieModel.path = "assets/images/motivation.jpg";
  categorieModel.categorieName = "Motivation";

  categories.add(categorieModel);
  categorieModel = CategorieModel();

  categorieModel.path = "assets/images/bike.jpg";
  categorieModel.categorieName = "Bikes";
  categories.add(categorieModel);
  categorieModel = CategorieModel();

  categorieModel.path = "assets/images/car.jpg";
  categorieModel.categorieName = "Cars";
  categories.add(categorieModel);
  categorieModel = CategorieModel();

  return categories;
}
