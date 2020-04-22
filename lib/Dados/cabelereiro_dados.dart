import 'package:agendacabelo/Dados/disponibilidade_dados.dart';
import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CabelereiroDados {
  String id;
  String nome;
  String apelido;
  DisponibilidadeDados horarioDados;
  PrecoDados precoDados;

  CabelereiroDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nome = snapshot.data["nome"];
    apelido = snapshot.data["apelido"];
    horarioDados = snapshot.data["horarioDados"];
    precoDados = snapshot.data["precoDados"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "apelido": apelido,
    };
  }

  Future cabelereiroFuture({String salao_id}) {
    if (salao_id.isNotEmpty) {
      return Firestore.instance
          .collection("usuarios")
          .where("salao", isEqualTo: salao_id)
          .getDocuments();
    }
    return Firestore.instance.collection("usuarios").getDocuments();
  }
}
