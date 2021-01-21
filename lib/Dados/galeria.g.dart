// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'galeria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Galeria _$GaleriaFromJson(Map<String, dynamic> json) {
  return Galeria()
    ..id = json['id'] as int
    ..descricao = json['descricao'] as String
    ..imagem = json['imagem'] as String
    ..cabeleireiroId = json['cabeleireiro_id'] as int
    ..salaoId = json['salao_id'] as int
    ..servicoId = json['servico_id'] as int
    ..clienteId = json['cliente_id'] as int
    ..servico = Galeria._servicoFromJSon(json['servico'])
    ..salao = Galeria._salaoFromJson(json['salao'])
    ..cabeleireiro = json['cabeleireiro'] == null
        ? null
        : Cabeleireiro.fromJson(json['cabeleireiro'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GaleriaToJson(Galeria instance) => <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'imagem': instance.imagem,
      'cabeleireiro_id': instance.cabeleireiroId,
      'salao_id': instance.salaoId,
      'servico_id': instance.servicoId,
      'cliente_id': instance.clienteId,
      'servico': Galeria._servicoToJson(instance.servico),
      'salao': instance.salao,
      'cabeleireiro': instance.cabeleireiro,
    };
