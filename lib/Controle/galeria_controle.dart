import 'dart:io';

import 'package:cortai/Dados/galeria.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GaleriaControle {
  static const _url = Util.url + "galeria/";

  static Uri get(int salaoId) {
    return Uri.parse(_url + salaoId.toString());
  }

  static Future<void> store(
      {required Galeria dados,
      required File imagem,
      required String token,
      required VoidCallback onSuccess,
      required void onFail(String error)}) async {
    Api api = Api();
    Map<String, dynamic> map = dados.toJson();
    map["imagem"] = await MultipartFile.fromFile(imagem.path,
        filename: imagem.path.split('/').last);
    try {
      await api.store(_url, map, token);
      onSuccess();
    } catch (e) {
      print(e);
      onFail(e.toString());
    }
  }
}
