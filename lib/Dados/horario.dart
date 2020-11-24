import 'dart:convert';

import 'package:cortai/Dados/servico.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Horario {
  int id;
  String hora;
  String data;
  bool confirmado;
  int cabeleireiro;
  String cliente;
  String servico;
  List<Servico> servico_api;
  bool pago;
  String formaPagamento;
  Servico servicoDados;

  Horario();

/*  Horario.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    horario = snapshot.data['horario'];
    data = snapshot.data['data'];
    cabeleireiro = snapshot.data['cabeleireiro'];
    cliente = snapshot.data['cliente'];
    confirmado = snapshot.data['confirmado'];
    servico = snapshot.data['servico'];
    pago = snapshot.data['pago'];
    formaPagamento = snapshot.data['formaPagamento'];

    servicoDados = Servico.fromMap(snapshot.data['servico_map'], servico);
  }*/

  Horario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hora = json['data']['horario'];
    data = json['data']['data'];
    cabeleireiro = json['data']['cabeleireiro'];
    cliente = json['data']['cliente'];
    confirmado = json['data']['confirmado'];
    servico = json['data']['servico'];
    pago = json['data']['pago'];
    formaPagamento = json['data']['formaPagamento'];
    servicoDados = Servico.fromMap(json['data']['servico_map'], servico);
  }

  Horario.fromJsonApi(Map<String, dynamic> json) {
    id = json['id'];
    hora = json['hora'];
    data = json['data'];
    cabeleireiro = json['cabeleireiro'];
    cliente = json['cliente'];
    confirmado = json['confirmado'] == 1;
    servico_api = json['servicos'].map<Servico>((s) {
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
      "servico": servico,
      'servico_map': servicoDados.toMap(),
    };
  }

  @override
  String toString() {
    return 'HorarioDados{id: $id, horario:'
        ' $hora, data: $data, confirmado: '
        '$confirmado, cabeleireiro: $cabeleireiro, '
        'cliente: $cliente, servico: $servico, pago:'
        ' $pago, formaPagamento: $formaPagamento}';
  }

  @override
  bool operator ==(dados) {
    return dados is Horario && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
