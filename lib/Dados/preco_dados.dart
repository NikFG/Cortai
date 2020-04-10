import 'package:cloud_firestore/cloud_firestore.dart';

class PrecoDados {
  String id;
  String descricao;
  double valor;

  PrecoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    descricao = snapshot.data["descricao"];
    valor = snapshot.data["valor"];
  }

  Map<String, dynamic> toMap() {
    return {
      "descricao": descricao,
      "valor": valor,
    };
  }
}
