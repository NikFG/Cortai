import 'package:cloud_firestore/cloud_firestore.dart';

class FormaPagamento {
  String id;
  String icone;
  String descricao;

  FormaPagamento.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    icone = snapshot.data['icone'];
    descricao = snapshot.data['descricao'];
  }
}
