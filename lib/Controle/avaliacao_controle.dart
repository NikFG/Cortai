import 'package:cortai/Dados/avaliacao.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';

class AvaliacaoControle {
  static String _url = Util.url + "avaliacoes";

  static String get(int salaoId) {
    return _url + "/${salaoId.toString()}";
  }

  static void store(Avaliacao dados,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {}

  static void update(Avaliacao dados,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {}
}
