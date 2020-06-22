import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
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
          if (model.dados != null)
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: HorarioControle.get()
                      .where('cliente', isEqualTo: model.dados.id)
                      .orderBy('data', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return lista(snapshot, context);
                    }
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: HorarioControle.get()
                      .where('cabeleireiro', isEqualTo: model.dados.id)
                      .orderBy('data', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return lista(snapshot, context);
                    }
                  },
                ),
              ],
            );
          else
            return Center();
        },
      ),
    );
  }

  ListView lista(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    var dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.documents.map((doc) {
              return MarcadoTile(HorarioDados.fromDocument(doc));
            }).toList(),
            color: Colors.grey[500],
            context: context)
        .toList();
    return ListView(children: dividedTiles);
  }
}
