import 'dart:io';

import 'package:cortai/Dados/login.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SalaoControle {
  static final _url = Util.url + "saloes/";

  static String get() {
    return _url + "home";
  }

  static String show(int id) {
    return _url + "show/${id.toString()}";
  }

  static void store(Salao dados,
      {@required Login usuario,
      @required File imagem,
      @required String token,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    Dio dio = Dio();
    Map<String, dynamic> map = dados.toMap();
    map["imagem"] = await MultipartFile.fromFile(imagem.path,
        filename: imagem.path.split('/').last);
    FormData formData = FormData.fromMap(map);

    try {
      var response = await dio.post(
        _url + "store",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print(response.data);
      onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static void update(Salao dados,
      {@required Login usuario,
      @required File imagem,
      @required String token,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    Dio dio = Dio();
    Map<String, dynamic> map = dados.toMap();
    if (imagem != null)
      map["imagem"] = await MultipartFile.fromFile(imagem.path,
          filename: imagem.path.split('/').last);
    FormData formData = FormData.fromMap(map);
    try {
      var response = await dio.post(
        _url + "edit/${dados.id.toString()}",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print(response.data);
      onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }
}
