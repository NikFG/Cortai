import 'package:cloud_firestore/cloud_firestore.dart';

class HorarioDados {
  String id;
  String horario;
  String data;
  bool ocupado;
  bool confirmado;
  String cabeleireiro;
  String cliente;
  String preco;

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
    };
  }

  disponibilidadeFuture(String cabeleireiroId) {
    return Firestore.instance
        .collection("usuarios")
        .document(cabeleireiroId)
        .collection("disponibilidade")
        .getDocuments();
  }

  @override
  String toString() {
    return 'HorarioDados{id: $id, horario: $horario,'
        ' data: $data, ocupado: $ocupado, confirmado:'
        ' $confirmado, cabeleireiro: $cabeleireiro, cliente: $cliente, preco: $preco}';
  }
}
