import 'package:cloud_firestore/cloud_firestore.dart';


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
}
