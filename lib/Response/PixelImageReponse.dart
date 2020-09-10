import 'package:wallpaperapp/Models/PixelImage.dart';

class PixelImageResponse {
  final List<PixelImage> images;
  final String error;
  final maxCount;
  PixelImageResponse.fromJson(Map<String, dynamic> json)
      : images = (json['photos'] as List)
            .map((img) => PixelImage.fromJson(img))
            .toList(),
        error = null,
        maxCount = json['total_results'];
  PixelImageResponse.withError(String error)
      : images = [],
        error = error,
        maxCount = null;
}
