import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  String baseUrl = 'https://open.er-api.com/v6/latest/';

  Future<Map<String, dynamic>> getRates(String base) async {
    var response = await http.get(Uri.parse(baseUrl + base));

    print(response.statusCode);

    return jsonDecode(response.body);
  }
}
