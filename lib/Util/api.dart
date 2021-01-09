import 'dart:async';

import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Api {
  Dio _dio;

  Api() {
    _dio = Dio();
  }

  static Future<http.Response> get(
      String url, String token, FutureOr onTimeout) {
    return http
        .get(url, headers: Util.token(token))
        .timeout(Duration(seconds: 10), onTimeout: onTimeout);
  }

  Future<void> store(
      String url, Map<String, dynamic> data, String token) async {
    var response = await _dio.post(url + "store",
        data: FormData.fromMap(data),
        options: Options(
            headers: Util.token(token),
            followRedirects: false,
            validateStatus: (status) {
              return status <= 500;
            }));
    if (response.statusCode == 422) {
      throw response.data;
    }
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

    if (response.statusCode == 422) {
      throw response.data;
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
      throw response.data;
    }
  }
}

/*
try {
Api api = Api();
await api.store(
"http://192.168.0.108:8000/api/saloes/store",
{
"nome": "teste",
"endereco": "abc",
},
model.token);
} catch (e) {
print("Tem um erro aqui2");
Map<String, dynamic> x = {};
x.forEach((key, value) {});
e.forEach((a, b) {
print(b
    .toString()
    .replaceAll('[', '')
    .replaceAll(']', ''));
});
}*/
