import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/servico.dart';

import 'cliente.dart';

class Horario {
  int id;
  String hora;
  String data;
  bool confirmado;
  Cabeleireiro cabeleireiro;
  int cabeleireiroId;
  Cliente cliente;
  int clienteId;
  List<Servico> servicos;
  bool pago;
  int formaPagamentoId;

  Horario();

  Horario.fromJsonApi(Map<String, dynamic> json) {
    id = json['id'];
    hora = json['hora'];
    data = json['data'];
    cabeleireiro = json['cabeleireiro'] != null
        ? Cabeleireiro.fromJson(json['cabeleireiro'])
        : Cabeleireiro();
    cliente =
        json['cliente'] != null ? Cliente.fromJson(json['cliente']) : Cliente();
    confirmado = json['confirmado'] == 1;
    servicos = json['servicos'].map<Servico>((s) {
      return Servico.fromJsonApi(s);
    }).toList();
    pago = json['pago'] == 1;
    formaPagamentoId = json['formaPagamento'];
  }

  Map<String, dynamic> toMap() {
    return {
      "cabeleireiro_id": cabeleireiroId,
      "cliente_id": clienteId,
      "confirmado": confirmado,
      "data": data.replaceAll("/", '-'),
      "forma_pagamento_id": formaPagamentoId,
      "hora": hora,
      "pago": pago,
      "servicos": servicos.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'HorarioDados{id: $id, horario:'
        ' $hora, data: $data, confirmado: '
        '$confirmado, cabeleireiro: $cabeleireiro, '
        'cliente: $cliente, pago:'
        ' $pago, formaPagamento: $formaPagamentoId}';
  }

  @override
  bool operator ==(dados) {
    return dados is Horario && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
