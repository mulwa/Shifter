import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(url) async {
    http.Response response = await http.get(url);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed $e';
    }
  }
}
