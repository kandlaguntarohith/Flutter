class FirebaseImage {
  final String id;
  final String photographer;
  final String compressedOriginal;
  final String original;
  final int height;
  final int width;
  FirebaseImage.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        photographer = json["photographer"],
        compressedOriginal = json["compressed"],
        original = json["original"],
        height = json['height'],
        width = json['width'];
}
