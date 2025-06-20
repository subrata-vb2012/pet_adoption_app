import 'package:dio/dio.dart';

class PetRepository {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchPets() async {
    const url = 'https://mocki.io/v1/6eef7aa9-e3ce-403f-96f3-438378dcc0b9';
    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception("Failed to load pets");
      }
    } catch (e) {
      rethrow;
    }
  }
}
