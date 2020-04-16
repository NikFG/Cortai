import 'package:cloud_firestore/cloud_firestore.dart';

import '../util.dart';

class DisponibilidadeDados {
  String id;
  String horario;
  bool ocupado;
  bool confirmado;
  DisponibilidadeDados();

  DisponibilidadeDados.fromDocument(DocumentSnapshot snapshot) {
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
}
