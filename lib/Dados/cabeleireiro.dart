import 'package:cloud_firestore/cloud_firestore.dart';

class Cabeleireiro {
  int id;
  String nome;
  int salao;

  Cabeleireiro();

  Cabeleireiro.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    salao = map['salao_id'];
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
