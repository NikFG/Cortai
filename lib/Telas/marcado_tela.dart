import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Tiles/marcado_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MarcadoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
          return Material(
            child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection('horarios')
                  .where('cliente', isEqualTo: model.dados['uid'])
                  .where('ocupado', isEqualTo: true)
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var dividedTiles = ListTile.divideTiles(
                          tiles: snapshot.data.documents.map((doc) {
                            return MarcadoTile(doc);
                          }).toList(),
                          color: Colors.grey[500],
                          context: context)
                      .toList();
                  return ListView(children: dividedTiles);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
