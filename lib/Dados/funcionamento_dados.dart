import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FuncionamentoDados {
  String diaSemana;
  String horarioAbertura;
  String horarioFechamento;
  int intervalo;

  FuncionamentoDados();

  FuncionamentoDados.fromDocument(DocumentSnapshot snapshot) {
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
