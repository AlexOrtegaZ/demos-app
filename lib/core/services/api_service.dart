import 'dart:convert';
import 'dart:io';
import 'package:demos_app/core/services/token.service.dart';
import 'package:demos_app/utils/ui/toast.util.dart';
import 'package:http/http.dart' as http;

class ApiSerivce {
  Map<String, String> _getDefaultHeaders() {
    Map<String, String> headers = {};
    String? accessToken = TokenService().accessToken;
    if (accessToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future<http.Response> get(String endpoint) {
    return http.get(Uri.parse(endpoint), headers: _getDefaultHeaders());
  }

  Future<Map<String, dynamic>> post(String endpoint, Object? body) async {
    Future<http.Response> call = http.post(Uri.parse(endpoint),
        headers: _getDefaultHeaders(), body: body);
    var response = await _handleErrors(call);
    return jsonDecode(response!.body);
  }

  Future<Map<String, dynamic>> patch(String endpoint, Object? body) async {
    Future<http.Response> call = http.patch(Uri.parse(endpoint),
        headers: _getDefaultHeaders(), body: body);
    var response = await _handleErrors(call);
    return jsonDecode(response!.body);
  }

  Future<Map<String, dynamic>> upload(String endpoint, File imageFile) async {
    var stream = new http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse(endpoint);

    var request = new http.MultipartRequest(
      "POST",
      uri,
    );
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: imageFile.path.split('/').last);

    request.headers.addAll(_getDefaultHeaders());
    request.files.add(multipartFile);

    Future<http.Response> call = http.Response.fromStream(await request.send());
    var response = await _handleErrors(call);
    return jsonDecode(response!.body);
  }

  Future<http.Response?> _handleErrors(Future<http.Response> call) async {
    try {
      http.Response response = await call;
      if (response.statusCode != 200) {
        await _handleServerErrors(response);
      }
      return response;
    } catch (err) {
      _throwMessageError(err.toString());
    }
  }

  Future<void> _handleServerErrors(http.Response response) async {
    var body = await jsonDecode(response.body);
    throw (body['message']);
  }

  void _throwMessageError(String message) {
    ToastUtil.showError(message);
    throw (message);
  }
}