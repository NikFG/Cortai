import 'package:cloud_firestore/cloud_firestore.dart';

class Avaliacao {
  String id;
  double avaliacao;
  String descricao;
  String data;
  String hora;
  String cabeleireiro;
  String salao;
  String horario;


  Avaliacao();

/*  Avaliacao.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    avaliacao = snapshot.data["avaliacao"];
    descricao =
        snapshot.data["descricao"] == null ? "" : snapshot.data['descricao'];
    data = snapshot.data["data"];
    hora = snapshot.data["hora"];
    cabeleireiro = snapshot.data["cabeleireiro"];
    salao = snapshot.data['salao'];
    horario = snapshot.data['horario'];
  }*/

  Map<String, dynamic> toMap() {
    return {
      "avaliacao": avaliacao,
      "descricao": descricao,
      "data": data,
      "hora": hora,
      "cabeleireiro": cabeleireiro,
      "salao": salao,
      "horario": horario,
    };
  }
}
