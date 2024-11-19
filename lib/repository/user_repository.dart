import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRepository {
  final String _baseUrl = 'https://localhost:44384/login';

  Future<String> login({
    required String username,
    required String password,
    required int role,
  }) async {
    final Uri url = Uri.parse(_baseUrl);

    final Map<String, dynamic> data = {
      "username": username,
      "password": password
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
