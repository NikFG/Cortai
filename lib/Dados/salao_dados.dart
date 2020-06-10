import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaoDados {
  String id;
  String nome;
  String endereco;
  String telefone;
  String imagem;
  double latitude;
  double longitude;

  SalaoDados();

  SalaoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nome = snapshot.data['nome'];
    endereco = snapshot.data['endereco'];
    telefone = snapshot.data['telefone'];
    imagem = snapshot.data['imagem'];
    latitude = snapshot.data['latitude'];
    longitude = snapshot.data['longitude'];
  }

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "endereco": endereco,
      "telefone": telefone,
      "imagem": imagem,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  store(SalaoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await Firestore.instance
        .collection('saloes')
        .add(dados.toMap())
        .then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  update(SalaoDados dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await Firestore.instance
        .collection('horarios')
        .document(dados.id)
        .updateData(dados.toMap())
        .then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }
}
