import 'package:cloud_firestore/cloud_firestore.dart';

class Funcionamento {
  String diaSemana;
  String horarioAbertura;
  String horarioFechamento;
  int intervalo;

  Funcionamento();

  Funcionamento.fromDocument(DocumentSnapshot snapshot) {
    diaSemana = snapshot.documentID;
    horarioAbertura = snapshot.data['horarioAbertura'];
    horarioFechamento = snapshot.data['horarioFechamento'];
    intervalo = snapshot.data['intervalo'];
  }

  Map<String, dynamic> toMap() {
    return {
      "horarioAbertura": horarioAbertura,
      "horarioFechamento": horarioFechamento,
      "intervalo": intervalo,
    };
  }
}
