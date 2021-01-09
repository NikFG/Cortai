import 'dart:io';

import 'package:cortai/Dados/servico.dart';
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
      {@required Servico dados,
      @required String token,
      @required File imagem,
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
      if (response.statusCode == 500) {
        onFail();
      } else
        onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static void update(
      {@required Servico dados,
      @required String token,
      @required File imagem,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    Dio dio = Dio();
    Map<String, dynamic> map = dados.toMap();
    if (imagem != null)
      map["imagem"] = await MultipartFile.fromFile(imagem.path,
          filename: imagem.path.split('/').last);
    FormData formData = FormData.fromMap(map);
    print(formData);
    try {
      var response = await dio.post(
        _url + "update/${dados.id.toString()}",
        data: formData,
        options: Options(headers: Util.token(token)),
      );
      print(response.data);
      if (response.statusCode == 500) {
        onFail();
      } else
        onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }
}
