import 'dart:convert';
import 'package:http/http.dart';
import 'package:samma_tv/source/core/exception.dart';


class ApiClient {
  final Client _client;

  ApiClient(this._client);

  dynamic get(Uri uri, {Map<dynamic, dynamic>? params}) async {
    print(uri);
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        "Access-Control-Allow-Origin": "*"
      },
    );
    if (response.statusCode == 200) {
      String source = Utf8Decoder().convert(response.bodyBytes);
      return json.decode(source);
    } else {
      throw ServerException();
    }
  }

  dynamic post(Uri uri, {Map<dynamic, dynamic>? params}) async {
    final response = await _client.post(
      uri,
      body: jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }

}