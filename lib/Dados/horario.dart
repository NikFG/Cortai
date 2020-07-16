import 'package:cloud_firestore/cloud_firestore.dart';

class Horario {
  String id;
  String horario;
  String data;
  bool confirmado;
  String cabeleireiro;
  String cliente;
  String servico;
  bool pago;
  String formaPagamento;

  Horario();

  Horario.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    horario = snapshot.data['horario'];
    data = snapshot.data['data'];
    cabeleireiro = snapshot.data['cabeleireiro'];
    cliente = snapshot.data['cliente'];
    confirmado = snapshot.data['confirmado'];
    servico = snapshot.data['servico'];
    pago = snapshot.data['pago'];
    formaPagamento = snapshot.data['formaPagamento'];
  }

  Map<String, dynamic> toMap() {
    return {
      "cabeleireiro": cabeleireiro,
      "cliente": cliente,
      "confirmado": confirmado,
      "data": data,
      "formaPagamento": formaPagamento,
      "horario": horario,
      "pago": pago,
      "servico": servico,
    };
  }

  @override
  String toString() {
    return 'HorarioDados{id: $id, horario:'
        ' $horario, data: $data, confirmado: '
        '$confirmado, cabeleireiro: $cabeleireiro, '
        'cliente: $cliente, servico: $servico, pago:'
        ' $pago, formaPagamento: $formaPagamento}';
  }
}
