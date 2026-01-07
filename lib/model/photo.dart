class Photo {
  final int id;
  final String photographer;
  final String imageUrl;
  final String photographerUrl;

  Photo({
    required this.id,
    required this.photographer,
    required this.imageUrl,
    required this.photographerUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? 0,

      photographer: json['user'] ?? 'Unknown',

      imageUrl: json['webformatURL'] ?? json['largeImageURL'] ?? '',

      photographerUrl: json['userImageURL'] ?? '',
    );
  }
}
