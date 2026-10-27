import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiClient {
  String baseUrl = 'https://open.er-api.com/v6/latest/';

  Future<Map<String, dynamic>> getRates(String base) async {
    http.Response response;

    try {
      response = await http
          .get(Uri.parse(baseUrl + base))
          .timeout(Duration(seconds: 10));
    } on SocketException {
      throw Exception('Нет подключения к интернету');
    } on TimeoutException {
      throw Exception('Сервер долго не отвечает');
    }

    print(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception('Ошибка сервера ' + response.statusCode.toString());
    }

    var data = jsonDecode(response.body);

    if (data['result'] != 'success') {
      throw Exception('Сервер вернул ошибку');
    }

    return data;
  }
}
