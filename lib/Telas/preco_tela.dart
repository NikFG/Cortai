import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Tiles/preco_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrecoTela extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PrecoTela(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Preços de " + this.snapshot.data['nome']),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("usuarios")
            .document(this.snapshot.documentID)
            .collection("precos")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
                padding: EdgeInsets.all(4),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 3),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  PrecoDados dados =
                      PrecoDados.fromDocument(snapshot.data.documents[index]);
                  return PrecoTile(dados, this.snapshot.documentID);
                });
          }
        },
      ),
    );
  }
}
