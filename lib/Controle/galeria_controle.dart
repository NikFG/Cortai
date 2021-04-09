import 'package:cortai/Dados/galeria.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';

class GaleriaControle {
  static const _url = Util.url + "galeria/";

  static Uri get(int salaoId) {
    return Uri.parse(_url + salaoId.toString());
  }

  static Future<void> store(Galeria dados, String token,
      {required VoidCallback onSuccess,
      required void onFail(String error)}) async {
    Api api = Api();
    try {
      await api.store(_url, dados.toJson(), token);
      onSuccess();
    } catch (e) {
      onFail(e.toString());
    }
  }
}
