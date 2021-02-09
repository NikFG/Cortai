import 'dart:io';

import 'package:cortai/Dados/login.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SalaoControle {
  static final _url = Util.url + "saloes/";

  static String get() {
    return _url + "home";
  }

  static String getCabeleireiros() {
    return _url + "cabeleireiros";
  }

  static String show(int id) {
    return _url + "show/${id.toString()}";
  }

  static void store(Salao dados,
      {@required Login usuario,
      @required File imagem,
      @required String token,
      @required VoidCallback onSuccess,
      @required void Function(String error) onFail}) async {
    Api api = Api();
    try {
      Map<String, dynamic> map = dados.toJson();
      if (imagem != null) {
        map["imagem"] = await MultipartFile.fromFile(imagem.path,
            filename: imagem.path.split("/").last);
      }
      usuario.salaoId = await api.store(_url, map, token) as int;
      onSuccess();
    } catch (e) {
      onFail(e.toString());
    }
  }

  static void update(Salao dados,
      {@required Login usuario,
      @required File imagem,
      @required String token,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    try {
      Api api = Api();
      Map<String, dynamic> map = dados.toJson();
      if (imagem != null)
        map["imagem"] = await MultipartFile.fromFile(imagem.path,
            filename: imagem.path.split('/').last);
      await api.update(_url, map, token, dados.id);
      onSuccess();
    } catch (e) {
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
}
