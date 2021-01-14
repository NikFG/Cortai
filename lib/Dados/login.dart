import 'package:cortai/Util/conversao.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  int id;
  String nome;
  @JsonKey(name: 'salao_id')
  int salaoId;
  String telefone;
  String email;
  String imagem;
  @JsonKey(name: 'is_cabeleireiro', fromJson: Conversao.trataBool)
  bool isCabeleireiro;
  @JsonKey(name: 'is_dono_salao', fromJson: Conversao.trataBool)
  bool isDonoSalao;
  @JsonKey(name: 'is_google', fromJson: Conversao.trataBool)
  bool isGoogle;
  String senha;

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Login.fromJson2(Map<String, dynamic> dados) {
    id = dados['id'];
    nome = dados['nome'];
    salaoId = dados['salao_id'];
    telefone = dados['telefone'];
    email = dados['email'];
    imagem = dados['imagem'];
    isCabeleireiro = dados['is_cabeleireiro'] == 1;
    isDonoSalao = dados['is_dono_salao'] == 1;
  }

  Login(
      {@required this.nome,
      this.salaoId,
      this.telefone,
      this.email,
      this.imagem,
      this.isCabeleireiro,
      this.isDonoSalao,
      this.id,
      this.senha,
      this.isGoogle = false});

  @override
  String toString() {
    return 'LoginDados{id: $id, nome: $nome, telefone: $telefone, email: '
        '$email, imagemUrl: $imagem, isCabeleireiro: '
        '$isCabeleireiro, isDonoSalao: $isDonoSalao}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': senha,
      'imagem': imagem,
      'nome': nome,
      'telefone': telefone,
      'salao_id': salaoId,
      'is_cabeleireiro': isCabeleireiro,
      'is_dono_salao': isDonoSalao,
      'is_google': isGoogle
    };
  }
}
