import 'package:agendacabelo/Dados/avaliacao_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AvaliacaoControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('avaliacoes');
  }

  static void store(AvaliacaoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore.collection('avaliacoes').add(dados.toMap()).then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(AvaliacaoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('avaliacoes')
        .document(dados.id)
        .setData(dados.toMap(), merge: true)
        .then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }
}
