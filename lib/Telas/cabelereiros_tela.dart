import 'package:agendacabelo/Telas/preco_tela.dart';
import 'package:agendacabelo/Tiles/cabelereiro_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CabelereirosTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("usuarios").getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var dividedTiles = ListTile.divideTiles(
                    tiles: snapshot.data.documents.map((doc) {
                      return CabelereiroTile(doc);
                    }).toList(),
                    color: Colors.grey[500],
                    context: context)
                .toList();

            return ListView(
              children: dividedTiles,
            );
          }
        },
      ),
    );
  }
}
