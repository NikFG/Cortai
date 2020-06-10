import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AvaliacaoDados {
  String id;
  double avaliacao;
  String cabeleireiro;
  String salao;
  String horario;

  AvaliacaoDados();

  AvaliacaoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    avaliacao = snapshot.data["avaliacao"];
    cabeleireiro = snapshot.data["cabeleireiro"];
    salao = snapshot.data['salao'];
    horario = snapshot.data['horario'];
  }

  Map<String, dynamic> toMap() {
    return {
      "avaliacao": avaliacao,
      "cabeleireiro": cabeleireiro,
      "salao": salao,
      "horario": horario
    };
  }

  store(AvaliacaoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await Firestore.instance
        .collection('avaliacoes')
        .add(dados.toMap())
        .then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  update(AvaliacaoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await Firestore.instance
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
