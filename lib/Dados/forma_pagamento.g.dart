// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forma_pagamento.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormaPagamento _$FormaPagamentoFromJson(Map<String, dynamic> json) {
  return FormaPagamento()
    ..id = json['id'] as int
    ..icone = json['imagem'] as String ?? ''
    ..descricao = json['descricao'] as String;
}

Map<String, dynamic> _$FormaPagamentoToJson(FormaPagamento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imagem': instance.icone,
      'descricao': instance.descricao,
    };
