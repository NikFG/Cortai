import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:json_annotation/json_annotation.dart';

part 'galeria.g.dart';

@JsonSerializable()
class Galeria {
  int id;
  String descricao;
  String imagem;
  @JsonKey(name: 'cabeleireiro_id')
  int cabeleireiroId;
  @JsonKey(name: 'salao_id')
  int salaoId;
  @JsonKey(name: 'servico_id')
  int servicoId;
  @JsonKey(name: 'cliente_id')
  int clienteId;
  @JsonKey(fromJson: _servicoFromJSon, toJson: _servicoToJson)
  Servico servico;
  @JsonKey(fromJson: _salaoFromJson)
  Salao salao;
  Cabeleireiro cabeleireiro;

  Galeria();

  factory Galeria.fromJson(Map<String, dynamic> json) =>
      _$GaleriaFromJson(json);

  Map<String, dynamic> toJson() => _$GaleriaToJson(this);

  static Servico _servicoFromJSon(Map<String, dynamic> servico) =>
      Servico.fromJsonApi(servico);

  static _servicoToJson(Servico servico) => servico.toMap();

  static Salao _salaoFromJson(Map<String, dynamic> salao) =>
      Salao.fromJsonApiDados(salao);
}
