import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRepository {
  final String _baseUrl = 'https://localhost:44384/login';

  Future<void> login({
    required String username,
    required String password,
    required int role,
  }) async {
    final Uri url = Uri.parse(_baseUrl);

    final Map<String, dynamic> data = {
      "Username": username,
      "Password": password,
      "Role": role,
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
        print('Login successful: ${response.body}');
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
