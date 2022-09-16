import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpManager {
  static void getData(String url,
      {Map<String, String>? headers,
      required Function success,
      required Function fail,
      required Function complete}) async {
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var result = json.decode(const Utf8Decoder().convert(response.bodyBytes));
        success(result);
      } else {
        throw Exception("Request failed with states: ${response.statusCode}");
      }
    } catch(e) {
      fail(e);
    } finally {
      complete();
    }
  }

  static Future requestData(String url, {Map<String, String>? headers}) async {
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var result = json.decode(const Utf8Decoder().convert(response.bodyBytes));
        return result;
      } else {
        throw Exception('"Request failed with status: ${response.statusCode}"');
      }
    } catch (e) {
      Future.error(e);
    }
  }
}
