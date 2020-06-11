import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HorarioControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('horarios');
  }

  static void store(HorarioDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore.collection('horarios').add(dados.toMap()).then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(HorarioDados dados,
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
