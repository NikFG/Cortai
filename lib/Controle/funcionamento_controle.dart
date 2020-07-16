import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/funcionamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FuncionamentoControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get(String salao) {
    return SalaoControle.get().document(salao).collection('funcionamento');
  }

  static void store(Funcionamento dados, String salao,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('saloes')
        .document(salao)
        .collection('funcionamento')
        .add(dados.toMap())
        .then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(Funcionamento dados, String salao,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('saloes')
        .document(salao)
        .collection('funcionamento')
        .document(dados.diaSemana)
        .updateData(dados.toMap())
        .then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }
}
