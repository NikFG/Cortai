// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avaliacao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Avaliacao _$AvaliacaoFromJson(Map<String, dynamic> json) {
  return Avaliacao()
    ..id = json['id'] as int
    ..valor = Conversao.strToDouble(json['valor'])
    ..observacao = json['observacao'] as String? ?? ''
    ..data = json['data'] as String
    ..horarioId = json['horario_id'] as int;
}

Map<String, dynamic> _$AvaliacaoToJson(Avaliacao instance) => <String, dynamic>{
      'id': instance.id,
      'valor': instance.valor,
      'observacao': instance.observacao,
      'data': instance.data,
      'horario_id': instance.horarioId,
    };
