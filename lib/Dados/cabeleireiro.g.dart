// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabeleireiro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cabeleireiro _$CabeleireiroFromJson(Map<String, dynamic> json) {
  return Cabeleireiro()
    ..id = json['id'] as int
    ..nome = json['nome'] as String
    ..salaoId = json['salao_id'] as int;
}

Map<String, dynamic> _$CabeleireiroToJson(Cabeleireiro instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'salao_id': instance.salaoId,
    };
