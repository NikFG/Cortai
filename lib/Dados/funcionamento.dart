import 'package:cloud_firestore/cloud_firestore.dart';

class Funcionamento {
  int id;
  String diaSemana;
  String horarioAbertura;
  String horarioFechamento;
  int intervalo;
  int salao_id;

  Funcionamento();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "dia_semana": diaSemana,
      "horario_abertura": horarioAbertura,
      "horario_fechamento": horarioFechamento,
      "intervalo": intervalo,
      "salao_id": salao_id
    };
  }

  Funcionamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diaSemana = json['dia_semana'];
    horarioAbertura = json['horario_abertura'];
    horarioFechamento = json['horario_fechamento'];
    intervalo = json['intervalo'];
    salao_id = json['salao_id'];
  }
}
