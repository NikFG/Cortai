import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Login {
  // String id;
  int id;
  String nome;
  String senha;
  String salao;
  int salao_id;
  String telefone;
  String email;
  String imagemUrl;
  bool isCabeleireiro;
  bool isDonoSalao;

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

  Login.fromJson(Map<String, dynamic> dados) {
    id = dados['id'];
    nome = dados['nome'];
    salao_id = dados['salao_id'];
    telefone = dados['telefone'];
    email = dados['email'];
    imagemUrl = dados['imagem'];
    isCabeleireiro = dados['is_cabeleireiro'] == 1;
    isDonoSalao = dados['is_dono_salao'] == 1;
  }

  Login.fromHorarioJson(Map<String, dynamic> json) {
    id = json['data']['usuario'];
    nome = json['cabeleireiro']['nome'];
    salao = json['cabeleireiro']['salao'];
    telefone = json['cabeleireiro']['telefone'];
    email = json['cabeleireiro']['email'];
    imagemUrl = json['cabeleireiro']['fotoURL'];
    isCabeleireiro = json['cabeleireiro']['cabeleireiro'];
    isDonoSalao = json['cabeleireiro']['donoSalao'];
  }

  Login({
    @required this.nome,
    this.salao,
    this.telefone,
    this.email,
    this.imagemUrl,
    this.isCabeleireiro,
    this.isDonoSalao,
    this.id,
    this.senha,
  });

  @override
  String toString() {
    return 'LoginDados{id: $id, nome: $nome, salao: '
        '$salao, telefone: $telefone, email: '
        '$email, imagemUrl: $imagemUrl, isCabeleireiro: '
        '$isCabeleireiro, isDonoSalao: $isDonoSalao}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': senha,
      'imagem': imagemUrl,
      'nome': nome,
      'telefone': telefone,
      'salao_id': salao,
      'is_cabeleireiro': isCabeleireiro,
      'is_dono_salao': isDonoSalao,
    };
  }
}
