class PixelImage {
  final id;
  final height;
  final width;
  final url;
  final photoGrapher;
  final portrait;
  final original;
  final compressedOriginal;
  PixelImage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        height = json['height'],
        width = json['width'],
        photoGrapher = json['photographer'],
        portrait = json['src']['portrait'],
        original = json['src']['original'],
        url = json['url'],
        compressedOriginal = json['src']['large'];
}
