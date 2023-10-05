import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'api_manager_response.dart';

enum RequestType { get, create, update, delete }

class APIManager {
  final _logger = Logger();

  /// baseUrl ends with slash , eg https://example.com/
  final String baseUrl;
  static APIManager? _instance;
  static APIManager getInstance(String baseUrl) {
    _instance ??= APIManager(baseUrl);
    return _instance!;
  }

  APIManager(this.baseUrl);

  Future<ApiManagerResponse> makeRequest({
    required endpoint,
    required RequestType requestType,
    Map<String, dynamic>? body,
  }) async {
    final url = "$baseUrl$endpoint";
    final uri = Uri.parse(url);
    _logger.d("call : $url");
    http.Response? response;
    try {
      response = await _makeRequestByType(requestType, uri: uri, body: body);

      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
      final log = {
        "url": url,
        "method": requestType.name,
        "body": body,
        "statusCode": response.statusCode,
        "response": isSuccess ? jsonDecode(response.body) : response.body
      };
      if (isSuccess) {
        _logger.d(log);
      } else {
        _logger.e(log);
      }
      final res = ApiManagerResponse(
        serverErrorMsg: "serverErrorMsg",
        statusCode: response.statusCode,
        isSuccess: isSuccess,
        rawData: response.body,
        error: response.body,
        data: isSuccess ? jsonDecode(response.body) : null,
      );
      return res;
    } catch (e) {
      _logger.e({
        "url": url,
        "method": requestType.name,
        "body": body,
        "statusCode": "Request Failed",
        "response": e.toString(),
      });
      return ApiManagerResponse(
        serverErrorMsg: "serverErrorMsg",
        statusCode: response?.statusCode ?? 0,
        isSuccess: false,
        rawData: null,
        error: e.toString(),
        data: null,
      );
    }
  }

  Future<http.Response> _makeRequestByType(
    RequestType requestType, {
    required Uri uri,
    Map<String, dynamic>? body,
  }) async {
    var client = http.Client();
    final Map<RequestType, Future<http.Response>> request = {
      RequestType.create: client.post(uri, body: jsonEncode(body)),
      RequestType.update: client.put(uri, body: body),
      RequestType.delete: client.delete(uri),
      RequestType.get: client.get(uri),
    };
    return await request[requestType]!;
  }
}
