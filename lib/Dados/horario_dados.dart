import 'package:cloud_firestore/cloud_firestore.dart';


class HorarioDados {
  String id;
  String horario;
  String data;
  bool ocupado;
  bool confirmado;
  String cabelereiro;
  String cliente;

  HorarioDados();

  HorarioDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    horario = snapshot.data['horario'];
    data = snapshot.data['data'];
    ocupado = snapshot.data["ocupado"];
    cabelereiro = snapshot.data['cabelereiro'];
    cliente = snapshot.data['cliente'];
    confirmado = snapshot.data['confirmado'];
  }

  Map<String, dynamic> toMap() {
    return {
      "horario": horario,
      "data": data,
      "ocupado": ocupado,
      "confirmado": confirmado,
      "cabelereiro": cabelereiro,
    };
  }

  Future disponibilidadeFuture(String cabelereiroId) {
    return Firestore.instance
        .collection("usuarios")
        .document(cabelereiroId)
        .collection("disponibilidade")
        .getDocuments();
  }

}
