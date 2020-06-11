import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaoControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('saloes');
  }

  static void store(SalaoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore.collection('saloes').add(dados.toMap()).then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(SalaoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('horarios')
        .document(dados.id)
        .updateData(dados.toMap())
        .then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }
}
