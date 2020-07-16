import 'package:agendacabelo/Dados/salao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaoControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('saloes');
  }

  static void store(Salao dados,
      {@required String usuario,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    await _firestore.collection('saloes').add(dados.toMap()).then((value) {
      print(value);
      Firestore.instance
          .collection('usuarios')
          .document(usuario)
          .updateData({'salao': value.documentID, 'cabeleireiro': true});
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(Salao dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('saloes')
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
