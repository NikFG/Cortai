import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Tiles/salao_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection('saloes')
            .orderBy('nome')
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.all(4),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 2.1),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              SalaoDados dados =
                  SalaoDados.fromDocument(snapshot.data.documents[index]);
              return SalaoTile(dados);  
            },
          );
        },
      ),
    );
  }

}
