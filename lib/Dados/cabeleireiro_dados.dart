import 'package:cloud_firestore/cloud_firestore.dart';

class CabeleireiroDados {
  String id;
  String nome;
  String salao;

  CabeleireiroDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nome = snapshot.data["nome"];
    salao = snapshot.data['salao'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "salao": salao,
    };
  }

  @override
  bool operator ==(dados) {
    return dados is CabeleireiroDados && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
