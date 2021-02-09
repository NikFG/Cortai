// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Horario _$HorarioFromJson(Map<String, dynamic> json) {
  return Horario()
    ..id = json['id'] as int
    ..hora = json['hora'] as String
    ..data = json['data'] as String
    ..confirmado = Conversao.trataBool(json['confirmado'])
    ..cabeleireiro = Horario._cabeleireiroFromJson(json['cabeleireiro'])
    ..cabeleireiroId = json['cabeleireiro_id'] as int
    ..cliente = Horario._clienteFromJson(json['cliente'])
    ..clienteId = json['cliente_id'] as int
    ..servicos = Horario._servicoFromJSon(json['servicos'])
    ..pago = Conversao.trataBool(json['pago'])
    ..formaPagamentoId = json['forma_pagamento_id'] as int;
}

Map<String, dynamic> _$HorarioToJson(Horario instance) => <String, dynamic>{
      'id': instance.id,
      'hora': instance.hora,
      'data': Horario._dataToJson(instance.data),
      'confirmado': instance.confirmado,
      'cabeleireiro': instance.cabeleireiro,
      'cabeleireiro_id': instance.cabeleireiroId,
      'cliente': instance.cliente,
      'cliente_id': instance.clienteId,
      'servicos': Horario._servicoToJson(instance.servicos),
      'pago': instance.pago,
      'forma_pagamento_id': instance.formaPagamentoId,
    };
