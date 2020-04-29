import 'package:cloud_firestore/cloud_firestore.dart';

import '../Util/util.dart';

class HorarioDados {
  String id;
  String horario;
  String data;
  bool ocupado;
  bool confirmado;

  HorarioDados();

  HorarioDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    horario = snapshot.data['horario'];
    data = snapshot.data['data'];
    ocupado = snapshot.data["ocupado"];
  }

  Map<String, dynamic> toMap() {
    return {
      "horario": horario,
      "data": data,
      "ocupado": ocupado,
      "confirmado": confirmado,
    };
  }

  Future disponibilidadeFuture(String cabelereiro_id) {
    return Firestore.instance
        .collection("usuarios")
        .document(cabelereiro_id)
        .collection("disponibilidade")
        .getDocuments();
  }
}
