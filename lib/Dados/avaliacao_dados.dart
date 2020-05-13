import 'package:cloud_firestore/cloud_firestore.dart';

class AvaliacaoDados {
  String id;
  double avaliacao;
  String cabelereiro;
  String salao;

  AvaliacaoDados();

  AvaliacaoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    avaliacao = snapshot.data["avaliacao"];
    cabelereiro = snapshot.data["cabelereiro"];
    salao = snapshot.data['salao'];
  }

  Map<String, dynamic> toMap() {
    return {
      "avaliacao": avaliacao,
      "cabelereiro": cabelereiro,
      "salao": salao,
    };
  }
}
