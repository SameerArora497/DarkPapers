class Images {

  final int imageID;
  final String imageAlt;
  final String imageUrl;

  const Images({
    required this.imageID,
    required this.imageAlt,
    required this.imageUrl,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      imageID: json["id"] as int? ?? 0,
      imageAlt: json["tags"] as String? ?? '',
      imageUrl: json["webformatURL"] as String? ?? '',
    );
  }

  Images.emptyConstructor(): imageID = 0, imageAlt = '', imageUrl = '';

}