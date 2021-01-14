import 'package:json_annotation/json_annotation.dart';

part 'funcionamento.g.dart';

@JsonSerializable()
class Funcionamento {
  int id;
  @JsonKey(name: 'dia_semana')
  String diaSemana;
  @JsonKey(name: 'horario_abertura')
  String horarioAbertura;
  @JsonKey(name: 'horario_fechamento')
  String horarioFechamento;
  int intervalo;
  @JsonKey(name: 'salao_id')
  int salaoId;

  Funcionamento();

  factory Funcionamento.fromJson(Map<String, dynamic> json) =>
      _$FuncionamentoFromJson(json);

  Funcionamento.fromJson2(Map<String, dynamic> json) {
    id = json['id'];
    diaSemana = json['dia_semana'];
    horarioAbertura = json['horario_abertura'];
    horarioFechamento = json['horario_fechamento'];
    intervalo = json['intervalo'];
    salaoId = json['salao_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "dia_semana": diaSemana,
      "horario_abertura": horarioAbertura,
      "horario_fechamento": horarioFechamento,
      "intervalo": intervalo,
      "salao_id": salaoId
    };
  }
}
