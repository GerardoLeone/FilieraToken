import 'dart:convert';
import 'package:http/http.dart' as http;

class JwtService {
  static const String _apiUrl = 'http://localhost:5050';
  static const String _apiGenerateJWT = '/generate-jwt-token';
  static const String _apiProtected = '/protected';
  static const String _apiInvalidateToken = '/invalidate-token';

  Future<String> generateJwtToken(Map<String, dynamic> data) async {
    print("Sono nel generate!");
    final response = await http.post(
      Uri.parse('$_apiUrl$_apiGenerateJWT'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['token'];
    } else {
      throw Exception('Failed to generate JWT token');
    }
  }

  Future<Map<String, dynamic>> validateJWT(String token) async {
        print("Sono nel validate!");
    final response = await http.get(
      Uri.parse('$_apiUrl$_apiProtected'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch protected data');
    }
  }

  Future<void> invalidateToken(String token) async {
        print("Sono nel invalidate!");
    final response = await http.post(
      Uri.parse('$_apiUrl$_apiInvalidateToken'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse['message']);
    } else {
      throw Exception('Failed to invalidate token');
    }
  }
}
