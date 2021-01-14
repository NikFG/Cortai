import 'package:json_annotation/json_annotation.dart';

part 'forma_pagamento.g.dart';

@JsonSerializable()
class FormaPagamento {
  int id;
  @JsonKey(name: 'imagem', defaultValue: '')
  String icone;
  String descricao;

  FormaPagamento();

  factory FormaPagamento.fromJson(Map<String, dynamic> json) =>
      _$FormaPagamentoFromJson(json);

  FormaPagamento.fromJson2(Map<String, dynamic> json) {
    id = json['id'];
    icone = json['imagem'] != null ? json['imagem'] : '';
    descricao = json['descricao'];
  }
}
