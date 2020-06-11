import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HorarioDados {
  String id;
  String horario;
  String data;
  bool ocupado;
  bool confirmado;
  String cabeleireiro;
  String cliente;
  String preco;
  bool pago;

  HorarioDados();

  HorarioDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    horario = snapshot.data['horario'];
    data = snapshot.data['data'];
    ocupado = snapshot.data["ocupado"];
    cabeleireiro = snapshot.data['cabeleireiro'];
    cliente = snapshot.data['cliente'];
    confirmado = snapshot.data['confirmado'];
    preco = snapshot.data['preco'];
    pago = snapshot.data['pago'];
  }

  Map<String, dynamic> toMap() {
    return {
      "cabeleireiro": cabeleireiro,
      "cliente": cliente,
      "confirmado": confirmado,
      "data": data,
      "horario": horario,
      "ocupado": ocupado,
      "preco": preco,
      "pago": pago,
    };
  }

  @override
  String toString() {
    return 'HorarioDados{id: $id, horario: $horario,'
        ' data: $data, ocupado: $ocupado, confirmado:'
        ' $confirmado, cabeleireiro: $cabeleireiro, cliente: $cliente, preco: $preco}';
  }
}
