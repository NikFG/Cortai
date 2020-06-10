import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicoDados {
  String id;
  String descricao;
  double valor;
  String imagemUrl;
  List<String> cabeleireiros;
  String salao;

  void setValor(String valor) {
    valor = valor.replaceAll("R\$", "");
    valor = valor.replaceAll(".", "");
    valor = valor.replaceAll(",", ".");
    this.valor = double.parse(valor);
  }

  ServicoDados();

  ServicoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    descricao = snapshot.data["descricao"];
    valor = snapshot.data["valor"];
    imagemUrl = snapshot.data["imagemUrl"];
    cabeleireiros = List.from(snapshot.data['cabeleireiros']);
  }

  Map<String, dynamic> toMap() {
    return {
      "descricao": descricao,
      "valor": valor,
      "imagemUrl": imagemUrl,
      'salao': salao,
      'cabeleireiros': cabeleireiros,
    };
  }

  store(ServicoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await Firestore.instance
        .collection('servicos')
        .add(dados.toMap())
        .then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  update(ServicoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await Firestore.instance
        .collection('servicos')
        .document(dados.id)
        .updateData(dados.toMap())
        .then((value) => onSuccess());
  }
}
