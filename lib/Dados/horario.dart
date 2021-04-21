import 'package:cortai/Dados/avaliacao.dart';
import "package:cortai/Dados/cabeleireiro.dart";
import "package:cortai/Dados/servico.dart";
import "package:cortai/Util/conversao.dart";
import "package:json_annotation/json_annotation.dart";

import "cliente.dart";

part "horario.g.dart";

@JsonSerializable()
class Horario {
  int? id;
  String? hora;
  @JsonKey(toJson: _dataToJson)
  String? data;
  @JsonKey(fromJson: Conversao.trataBool)
  bool? confirmado;
  @JsonKey(fromJson: _cabeleireiroFromJson)
  Cabeleireiro? cabeleireiro;
  @JsonKey(name: "cabeleireiro_id")
  int? cabeleireiroId;
  @JsonKey(fromJson: _clienteFromJson)
  Cliente? cliente;
  @JsonKey(name: "cliente_id")
  int? clienteId;
  @JsonKey(fromJson: _servicoFromJSon, toJson: _servicoToJson)
  List<Servico>? servicos;
  @JsonKey(fromJson: Conversao.trataBool)
  bool? pago;
  @JsonKey(name: "forma_pagamento_id")
  int? formaPagamentoId;
  @JsonKey(fromJson: _avaliacaoFromJson)
  Avaliacao? avaliacao;

  Horario();

  factory Horario.fromJson(Map<String, dynamic> json) =>
      _$HorarioFromJson(json);

  static Cabeleireiro _cabeleireiroFromJson(cabeleireiro) =>
      cabeleireiro != null
          ? Cabeleireiro.fromJson(cabeleireiro)
          : Cabeleireiro();

  static Cliente _clienteFromJson(cliente) =>
      cliente != null ? Cliente.fromJson(cliente) : Cliente();

  static List<Servico> _servicoFromJSon(List<dynamic>? servicos) =>
      servicos != null
          ? servicos.map<Servico>((s) => Servico.fromJsonApi(s)).toList()
          : [];

  static _servicoToJson(List<Servico>? servicos) =>
      servicos!.map((e) => e.toJson()).toList();

  static String _dataToJson(String? data) => data!.replaceAll("/", "-");

  Map<String, dynamic> toJson() => _$HorarioToJson(this);

  @override
  String toString() {
    return "HorarioDados{id: $id, horario:"
        " $hora, data: $data, confirmado: "
        "$confirmado, cabeleireiro: $cabeleireiro, "
        "cliente: $cliente, pago:"
        " $pago, formaPagamento: $formaPagamentoId}";
  }

  static Avaliacao? _avaliacaoFromJson(Map<String, dynamic>? map) {
    if (map != null) {
      return Avaliacao.fromJson(map);
    }
  }

  @override
  bool operator ==(dados) {
    return dados is Horario && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
