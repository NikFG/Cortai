import 'dart:convert';

import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cliente.dart';

class Horario {
  int id;
  String hora;
  String data;
  bool confirmado;
  Cabeleireiro cabeleireiro;
  Cliente cliente;
  List<Servico> servicos;
  bool pago;
  String formaPagamento;

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
    formaPagamento = json['formaPagamento'];
  }

  Map<String, dynamic> toMap() {
    return {
      "cabeleireiro": cabeleireiro,
      "cliente": cliente,
      "confirmado": confirmado,
      "data": data,
      "formaPagamento": formaPagamento,
      "horario": hora,
      "pago": pago,
    };
  }

  @override
  String toString() {
    return 'HorarioDados{id: $id, horario:'
        ' $hora, data: $data, confirmado: '
        '$confirmado, cabeleireiro: $cabeleireiro, '
        'cliente: $cliente, pago:'
        ' $pago, formaPagamento: $formaPagamento}';
  }

  @override
  bool operator ==(dados) {
    return dados is Horario && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
