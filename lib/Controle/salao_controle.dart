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
    if (imagem != null)
      map["imagem"] = await MultipartFile.fromFile(imagem.path,
          filename: imagem.path.split('/').last);
    FormData formData = FormData.fromMap(map);

    try {
      var response = await dio.post(
        _url + "store",
        data: formData,
        options: Options(headers: Util.token(token)),
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
        options: Options(headers: Util.token(token)),
      );
      print(response.data);
      onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static Future<Null> adicionaCabeleireiro(
      {@required String email,
      @required String token,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    Dio dio = Dio();
    try {
      var response = await dio.patch(_url + "edit/cabeleireiro/$email",
          options: Options(headers: Util.token(token)));
      print(response.data);
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onFail();
      }
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static String getCabeleireiros() {
    return _url + "cabeleireiros";
  }
}
