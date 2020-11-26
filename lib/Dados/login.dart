import 'package:flutter/material.dart';

class Login {
  // String id;
  int id;
  String nome;
  String senha;
  int salaoId;
  String telefone;
  String email;
  String imagemUrl;
  bool isCabeleireiro;
  bool isDonoSalao;

  Login.fromJson(Map<String, dynamic> dados) {
    id = dados['id'];
    nome = dados['nome'];
    salaoId = dados['salao_id'];
    telefone = dados['telefone'];
    email = dados['email'];
    imagemUrl = dados['imagem'];
    isCabeleireiro = dados['is_cabeleireiro'] == 1;
    isDonoSalao = dados['is_dono_salao'] == 1;
  }

  Login({
    @required this.nome,
    this.salaoId,
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
    return 'LoginDados{id: $id, nome: $nome, telefone: $telefone, email: '
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
      'salao_id': salaoId,
      'is_cabeleireiro': isCabeleireiro,
      'is_dono_salao': isDonoSalao,
    };
  }
}
