import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CabelereiroDados {
  String id;
  String nome;
  String salao;


  CabelereiroDados.fromDocument(DocumentSnapshot snapshot) {
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
