// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funcionamento.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Funcionamento _$FuncionamentoFromJson(Map<String, dynamic> json) {
  return Funcionamento()
    ..id = json['id'] as int?
    ..diaSemana = json['dia_semana'] as String
    ..horarioAbertura = json['horario_abertura'] as String
    ..horarioFechamento = json['horario_fechamento'] as String
    ..intervalo = json['intervalo'] as int
    ..salaoId = json['salao_id'] as int;
}

Map<String, dynamic> _$FuncionamentoToJson(Funcionamento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dia_semana': instance.diaSemana,
      'horario_abertura': instance.horarioAbertura,
      'horario_fechamento': instance.horarioFechamento,
      'intervalo': instance.intervalo,
      'salao_id': instance.salaoId,
    };
