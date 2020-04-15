import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaoDados {
  String id;
  String nome;
  String endereco;

  SalaoDados();

  SalaoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nome = snapshot.data["nome"];
    endereco = snapshot.data["endereco"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "endereco": endereco,
    };
  }
}
