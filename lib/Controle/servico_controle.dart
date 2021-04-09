import 'dart:io';

import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ServicoControle {
  static const _url = Util.url + "servicos/";

  static String getServicoCabeleireiro() {
    return _url + 'cabeleireiro';
  }

  static String getBySalao(int salaoId) {
    return _url + "salao/" + salaoId.toString();
  }

  static void store(
      {required Servico dados,
      required String token,
      required File imagem,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    Map<String, dynamic> map = dados.toJson();
    if (imagem != null)
      map["imagem"] = await MultipartFile.fromFile(imagem.path,
          filename: imagem.path.split('/').last);
    try {
      Api api = Api();
      await api.store(_url, map, token);
      onSuccess();
    } catch (e) {
      onFail();
    }
  }

  static void update(
      {required Servico dados,
      required String token,
      required File imagem,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    Map<String, dynamic> map = dados.toJson();
    if (imagem != null)
      map["imagem"] = await MultipartFile.fromFile(imagem.path,
          filename: imagem.path.split('/').last);
    Api api = Api();
    try {
      await api.update(_url, map, token, dados.id!);
      onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }
}
