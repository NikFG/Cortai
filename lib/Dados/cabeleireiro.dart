import 'package:cloud_firestore/cloud_firestore.dart';

class Cabeleireiro {
  String id;
  String nome;
  String salao;

  Cabeleireiro();

  Cabeleireiro.fromJson(Map<String, dynamic> map) {
    id = map['id'].toString();
    nome = map['nome'];
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
    return dados is Cabeleireiro && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
