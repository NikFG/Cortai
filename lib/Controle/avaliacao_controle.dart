import 'package:cortai/Dados/avaliacao.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AvaliacaoControle {
  static String _url = Util.url + "avaliacoes/";

  static String get(int salaoId) {
    return _url + "${salaoId.toString()}";
  }

  static void store(Avaliacao dados,
      {@required token,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    Dio dio = Dio();
    FormData data = FormData.fromMap(dados.toMap());
    var response = await dio.post(_url + "store",
        data: data, options: Options(headers: Util.token(token)));
    if (response.statusCode == 200) {
      onSuccess();
    } else {
      onFail();
    }
  }

  static void update(Avaliacao dados,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {}
}
