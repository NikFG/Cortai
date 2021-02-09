import 'package:cortai/Dados/avaliacao.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AvaliacaoControle {
  static String _url = Util.url + "avaliacoes/";

  static String get(int salaoId) {
    return _url + "${salaoId.toString()}";
  }

  static void store(Avaliacao dados,
      {@required String token,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    try {
      Api api = Api();
      await api.store(_url, dados.toJson(), token);
    } catch (e) {
      onFail();
    }
  }

  static void update(Avaliacao dados,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {}
}
