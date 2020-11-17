import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FuncionamentoControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get(String salao) {
    return SalaoControle.get().document(salao).collection('funcionamento');
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

  static void updateAll(List<Funcionamento> dados, String salao,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      dados.forEach((doc) async {
        await get(salao)
            .document(doc.diaSemana)
            .setData(doc.toMap());
      });
      onSuccess();
    } catch (e) {
      onFail();
    }
  }

  static void delete(String diaSemana, String salao,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await get(salao).document(diaSemana).delete().then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void deleteAll(String salao,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      var docs =
          await get(salao).getDocuments().then((value) => value.documents);
      docs.forEach((element) {
        get(salao).document(element.documentID).delete();
      });
      onSuccess();
    } catch (e) {
      onFail();
    }
  }
}
