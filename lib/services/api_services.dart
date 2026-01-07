import 'package:dio/dio.dart';
import 'package:my_app/model/photo.dart';

class ApiService {
  static const String apiKey = 'PIXABAY_API_KEY';
  static const String baseUrl = 'https://pixabay.com/api/';
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<List<Photo>> fetchPhotos({
    int page = 1,
    int perPage = 15,
    String query = 'nature',
  }) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'key': apiKey,
          'q': query,
          'image_type': 'photo',
          'page': page,
          'per_page': perPage,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final hits = data['hits'] as List;

      return hits.map((item) => Photo.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
