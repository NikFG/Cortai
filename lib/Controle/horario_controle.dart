import 'package:cortai/Dados/horario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';

class HorarioControle {
  static var _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('horarios');
  }

  static String _url = Util.url + "horarios/";

  static String getNew(String tipo, int pago) {
    return _url + "$tipo/${pago.toString()}";
  }

  static String getCabeleireiro(String tipo, int confirmado) {
    return _url + "$tipo/${confirmado.toString()}";
  }

  static void store(Horario dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await get().add(dados.toMap()).then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(Horario dados,
      {@required VoidCallback onSuccess(context),
      @required VoidCallback onFail(context),
      @required context}) async {
    await get()
        .document(dados.id.toString())
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

  /*
  * Recria o horário na coleção de horários excluídos para depois deletar.
  * Feito para armazenar os dados e ter controle futuro após o cancelamento
  * */

  static cancelaAgendamento(Horario dados,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail,
      clienteCancelou = false}) async {
    Map<String, dynamic> horario = dados.toMap();
    horario['clienteCancelou'] = clienteCancelou;
    await Firestore.instance
        .collection('horariosExcluidos')
        .add(horario)
        .catchError((e) {
      print(e);
      onFail();
    });
    await delete(dados.id.toString(), onSuccess: onSuccess, onFail: onFail);
  }

  static confirmaPagamento(String id,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore.collection("horarios").document(id).updateData({
      "pago": true,
    }).then((value) {
      print("Ok");
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }
}
