import 'package:agendacabelo/Dados/forma_pagamento_dados.dart';
import 'package:agendacabelo/Tiles/forma_pagamento_tile.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormaPagamentoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Formas de pagamento"),
        leading: Util.leadingScaffold(context),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection('formaPagamento')
            .orderBy("descricao")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tiles = ListTile.divideTiles(
                    tiles: snapshot.data.documents
                        .map((doc) => FormaPagamentoTile(
                            FormaPagamentoDados.fromDocument(doc)))
                        .toList(),
                    color: Colors.grey[500],
                    context: context)
                .toList();
            return ListView(
              children: tiles,
            );
          }
        },
      ),
//      body: ListView(
//        children: <Widget>[
//          ListTile(
//            leading: Icon(FontAwesome5.money_bill_alt,color: Colors.lightGreen,),
//            title: Text("Dinheiro"),
//          ),
//          ListTile(
//            leading: Icon(FontAwesome.credit_card),
//            title: Text("Cartão de crédito (maquininha)"),
//          ),
//          ListTile(
//            leading: Icon(FontAwesome5.credit_card),
//            title: Text("Cartão de débito (maquininha)"),
//          ),
//        ],
//      ),
    );
  }
}
