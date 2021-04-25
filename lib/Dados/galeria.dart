import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:json_annotation/json_annotation.dart';

part 'galeria.g.dart';

@JsonSerializable()
class Galeria {
  int? id;
  late String descricao;
  String? imagem;
  @JsonKey(fromJson: _servicoFromJSon, toJson: _servicoToJson)
  late Servico servico;
  @JsonKey(fromJson: _salaoFromJson, toJson: _salaoToJson)
  late Salao salao;
  late Cabeleireiro cabeleireiro;

  Galeria();

  factory Galeria.fromJson(Map<String, dynamic> json) =>
      _$GaleriaFromJson(json);

  Map<String, dynamic> toJson() => _$GaleriaToJson(this);

  static Servico _servicoFromJSon(Map<String, dynamic> servico) =>
      Servico.fromJsonApi(servico);

  static _servicoToJson(Servico servico) => servico.toJson();

  static Salao _salaoFromJson(Map<String, dynamic> salao) =>
      Salao.fromJsonApiDados(salao);

  static _salaoToJson(Salao salao) => salao.toJson();
}
