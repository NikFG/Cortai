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
      {@required VoidCallback onSuccess(context),
      @required VoidCallback onFail(context),
      @required context}) async {
    await _firestore
        .collection('horarios')
        .document(dados.id)
        .updateData(dados.toMap())
        .then((value) {
      onSuccess(context);
    }).catchError((e) {
      print(e);
      onFail(context);
    });
  }

  static delete(String id,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) {
    _firestore.collection("horarios").document(id).delete().then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static confirmaAgendamento(String id,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required BuildContext context}) async {
    await _firestore.collection("horarios").document(id).updateData({
      "confirmado": true,
    }).then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static cancelaAgendamento(HorarioDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await Firestore.instance
        .collection('horariosExcluidos')
        .add(dados.toMap())
        .catchError((e) {
      print(e);
      onFail();
    });
    await delete(dados.id, onSuccess: onSuccess, onFail: onFail);
  }

  static confirmaPagamento(String id,
      {@required VoidCallback onSuccess(context),
      @required VoidCallback onFail(context),
      @required BuildContext context}) async {
    await _firestore.collection("horarios").document(id).updateData({
      "pago": true,
    }).then((value) {
      onSuccess(context);
    }).catchError((e) {
      print(e);
      onFail(context);
    });
  }
}
