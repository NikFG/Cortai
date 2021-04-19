import 'dart:io';

import 'package:cortai/Dados/login.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SalaoControle {
  static final _url = Util.url + "saloes/";

  static Uri get(String param) {
    return Uri.parse(_url + "home" + param);
  }

  static Uri getCabeleireiros() {
    return Uri.parse(_url + "cabeleireiros");
  }

  static Uri show(int id) {
    return Uri.parse(_url + "show/${id.toString()}");
  }

  static Future<void> store(Salao dados,
      {required Login usuario,
      required File? imagem,
      required String token,
      required VoidCallback onSuccess,
      required void Function(String error) onFail,
      required Future<bool> Function() carregarDados}) async {
    Api api = Api();
    try {
      Map<String, dynamic> map = dados.toJson();
      if (imagem != null) {
        map["imagem"] = await MultipartFile.fromFile(imagem.path,
            filename: imagem.path.split("/").last);
      }
      usuario.salaoId = await api.store(_url, map, token) as int;
      await carregarDados();
      onSuccess();
    } catch (e) {
      onFail(e.toString());
    }
  }

  static Future<void> update(Salao dados,
      {required Login usuario,
      required File? imagem,
      required String token,
      required VoidCallback onSuccess,
      required VoidCallback onFail,
      required Future<bool> Function() carregarDados}) async {
    try {
      Api api = Api();
      Map<String, dynamic> map = dados.toJson();
      if (imagem != null)
        map["imagem"] = await MultipartFile.fromFile(imagem.path,
            filename: imagem.path.split('/').last);
      await api.update(_url, map, token, dados.id!);
      await carregarDados();
      onSuccess();
    } catch (e) {
      onFail();
    }
  }

  static Future<Null> adicionaCabeleireiro(
      {required String email,
      required String token,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
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
