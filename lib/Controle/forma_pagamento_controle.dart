import 'package:agendacabelo/Dados/cabeleireiro_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormaPagamentoControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('formaPagamento');
  }
}
