import 'package:json_annotation/json_annotation.dart';

part 'funcionamento.g.dart';

@JsonSerializable()
class Funcionamento {
  int? id;
  @JsonKey(name: 'dia_semana')
  late String diaSemana;
  @JsonKey(name: 'horario_abertura')
  late String horarioAbertura;
  @JsonKey(name: 'horario_fechamento')
  late String horarioFechamento;
  late int intervalo;
  @JsonKey(name: 'salao_id')
  late int salaoId;

  Funcionamento();

  factory Funcionamento.fromJson(Map<String, dynamic> json) =>
      _$FuncionamentoFromJson(json);

  Map<String, dynamic> toJson() => _$FuncionamentoToJson(this);
}
