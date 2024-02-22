import 'package:http/http.dart' as http;
import 'package:json_serializable/json_serializable.dart';


class UserSerivce {

  late final String _baseUrl;



    Future<void> registrationUser(String username, String email) async {
    /*final url = '$_baseUrl/api/v1/namespaces/default/identities';
    final body = {
      'type': 'user',
      'username': username,
      'email': email,
    };
    final headers = {
      'Authorization': 'Bearer $_authToken',
      'Content-Type': 'application/json',
    };
    return http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));*/
  }
}