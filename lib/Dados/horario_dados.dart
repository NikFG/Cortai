import 'package:cloud_firestore/cloud_firestore.dart';

import '../Util/util.dart';

class HorarioDados {
  String id;
  String horario;
  bool ocupado;
  bool confirmado;

  HorarioDados();

  HorarioDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    horario = Util.TimestampToString(snapshot.data["horario"]);
    ocupado = snapshot.data["ocupado"];
  }

  Map<String, dynamic> toMap() {
    return {
      "horario": Util.StringToTimestamp(horario),
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
