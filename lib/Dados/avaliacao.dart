import 'package:cloud_firestore/cloud_firestore.dart';

import 'horario.dart';

class Avaliacao {
  int id;
  double valor;
  String observacao;
  String data;
  String cabeleireiro;
  String salao;
  int horarioId;

  Avaliacao();

  Avaliacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valor = (json['valor'] as num).toDouble();
    observacao = json['observacao'] != null ? json['observacao'] : '';
    data = json['data'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "avaliacao": valor,
      "descricao": observacao,
      "data": data,
      "cabeleireiro": cabeleireiro,
      "salao": salao,
      "horario": horarioId,
    };
  }
}
