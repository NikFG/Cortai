import 'package:agendacabelo/Tiles/confirmar_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfirmarTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("cabelereiros")
            .document("GMy6pGj4ryDJLCZvnjoy")
            .collection("horarios")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var dividedTiles = ListTile.divideTiles(
                    tiles: snapshot.data.documents.map((doc) {
                      return ConfirmarTile(doc);
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
