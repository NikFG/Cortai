import 'package:cloud_firestore/cloud_firestore.dart';

class FormaPagamentoDados {
  String id;
  String icone;
  String descricao;

  FormaPagamentoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    icone = snapshot.data['icone'];
    descricao = snapshot.data['descricao'];
  }
}
