import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Login {
  String id;
  String nome;
  String salao;
  String telefone;
  String email;
  String imagemUrl;
  bool isCabeleireiro;
  bool isDonoSalao;

  Login.fromMap(Map<String, dynamic> dados) {
    id = dados['uid'];
    nome = dados['nome'];
    salao = dados['salao'];
    telefone = dados['telefone'];
    email = dados['email'];
    imagemUrl = dados['fotoURL'];
    isCabeleireiro = dados['cabeleireiro'];
    isDonoSalao = dados['donoSalao'];
  }
  Login.fromDocument(DocumentSnapshot dados) {
    id = dados['uid'];
    nome = dados['nome'];
    salao = dados['salao'];
    telefone = dados['telefone'];
    email = dados['email'];
    imagemUrl = dados['fotoURL'];
    isCabeleireiro = dados['cabeleireiro'];
    isDonoSalao = dados['donoSalao'];
  }

  Login(
      {
      @required this.nome,
      @required this.salao,
      @required this.telefone,
      @required this.email,
      @required this.imagemUrl,
      @required this.isCabeleireiro,
      @required this.isDonoSalao,
      this.id,
      }

      );

  @override
  String toString() {
    return 'LoginDados{id: $id, nome: $nome, salao: '
        '$salao, telefone: $telefone, email: '
        '$email, imagemUrl: $imagemUrl, isCabeleireiro: '
        '$isCabeleireiro, isDonoSalao: $isDonoSalao}';
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email,
      'fotoURL': imagemUrl,
      'nome': nome,
      'telefone': telefone,
      'salao': salao,
      'cabeleireiro': isCabeleireiro,
      'donoSalao': isDonoSalao,
    };
  }
}
