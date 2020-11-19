import 'package:cortai/Dados/servico.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortai/Util/util.dart';

import 'package:flutter/material.dart';

class ServicoControle {
  static Firestore _firestore = Firestore.instance;
  static const _url = Util.url + "servicos/";

  static CollectionReference get() {
    return _firestore.collection('servicos');
  }

  static String getBySalao(int salaoId) {
    return _url + "salao/" + salaoId.toString();
  }

  static void store(Servico dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore.collection('servicos').add(dados.toMap()).then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(Servico dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('servicos')
        .document(dados.id.toString())
        .updateData(dados.toMap())
        .then((value) => onSuccess());
  }
}
