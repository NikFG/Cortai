import 'dart:async';

import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Api {
  Dio _dio;

  Api() {
    _dio = Dio();
  }

  static Future<http.Response> get(String url, String token) {
    return http
        .get(url, headers: Util.token(token))
        .timeout(Duration(seconds: 10));
  }

  Future<dynamic> store(
      String url, Map<String, dynamic> data, String token) async {
    var response = await _dio.post(url + "store",
        data: FormData.fromMap(data),
        options: Options(
            headers: Util.token(token),
            followRedirects: false,
            validateStatus: (status) {
              return status <= 500;
            }));
    if (response.statusCode != 200) {
      throw _formataErro(response.data);
    }
    return response.data;
  }

  Future<void> update(
      String url, Map<String, dynamic> data, String token, int id) async {
    var response = await _dio.post(url + "edit/" + id.toString(),
        data: FormData.fromMap(data),
        options: Options(
            headers: Util.token(token),
            followRedirects: false,
            validateStatus: (status) {
              return status <= 500;
            }));

    if (response.statusCode != 200) {
      throw _formataErro(response.data);
    }
  }

  void delete(String url, String token, int id) async {
    var response = await _dio.delete(url + "delete/" + id.toString(),
        options: Options(
            headers: Util.token(token),
            followRedirects: false,
            validateStatus: (status) {
              return status <= 500;
            }));
    if (response.statusCode == 422) {
      throw _formataErro(response.data);
    }
  }

  String _formataErro(response) {
    String error = "";
    response.forEach((k, v) {
      error += v.toString().replaceFirst('[', '').replaceFirst(']', '') + "\n";
    });
    return error;
  }
}
