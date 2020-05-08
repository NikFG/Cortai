import 'package:cloud_firestore/cloud_firestore.dart';

class FuncionamentoDados {
  String diaSemana;
  String horarioAbertura;
  String horarioFechamento;

  FuncionamentoDados();

  FuncionamentoDados.fromDocument(DocumentSnapshot snapshot) {
    diaSemana = snapshot.documentID;
    horarioAbertura = snapshot.data['horarioAbertura'];
    horarioFechamento = snapshot.data['horarioFechamento'];
  }

  Map<String, dynamic> toMap() {
    return {
      "horarioAbertura": horarioAbertura,
      "horarioFechamento": horarioFechamento,
    };
  }
}
