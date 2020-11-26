import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/servico.dart';

import 'cliente.dart';

class Horario {
  int id;
  String hora;
  String data;
  bool confirmado;
  Cabeleireiro cabeleireiro;
  int cabeleireiro_id;
  Cliente cliente;
  int cliente_id;
  List<Servico> servicos;
  bool pago;
  int formaPagamento_id;

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
    formaPagamento_id = json['formaPagamento'];
  }

  Map<String, dynamic> toMap() {
    return {
      "cabeleireiro_id": cabeleireiro_id,
      "cliente_id": cliente_id,
      "confirmado": confirmado,
      "data": data.replaceAll("/", '-'),
      "forma_pagamento_id": formaPagamento_id,
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
        ' $pago, formaPagamento: $formaPagamento_id}';
  }

  @override
  bool operator ==(dados) {
    return dados is Horario && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
