import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Tiles/confirmar_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ConfirmarTela extends StatefulWidget {
  @override
  _ConfirmarTelaState createState() => _ConfirmarTelaState();
}

class _ConfirmarTelaState extends State<ConfirmarTela> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.dados != null)
          return TabBarView(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream: HorarioControle.get()
                      .where('confirmado', isEqualTo: false)
                      .where('cabeleireiro', isEqualTo: model.dados.id)
                      .orderBy('data')
                      .orderBy('horario')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data.documents.length == 0) {
                        return Center(
                          child: Text("Não há agendamentos para confirmar"),
                        );
                      }
                      var dividedTiles = ListTile.divideTiles(
                              tiles: snapshot.data.documents.map((doc) {
                                return ConfirmarTile(
                                    HorarioDados.fromDocument(doc), true);
                              }).toList(),
                              color: Colors.grey[500],
                              context: context)
                          .toList();
                      return ListView(
                        children: dividedTiles,
                      );
                    }
                  }),
              FutureBuilder<QuerySnapshot>(
                  future: HorarioControle.get()
                      .where('confirmado', isEqualTo: true)
                      .where('cabeleireiro', isEqualTo: model.dados.id)
                      .orderBy('data')
                      .orderBy('horario')
                      .getDocuments(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data.documents.length == 0) {
                        return Center(
                          child: Text("Não há agendamentos para confirmar"),
                        );
                      }
                      var dividedTiles = ListTile.divideTiles(
                              tiles: snapshot.data.documents.map((doc) {
                                return ConfirmarTile(
                                    HorarioDados.fromDocument(doc), false);
                              }).toList(),
                              color: Colors.grey[500],
                              context: context)
                          .toList();
                      return ListView(
                        children: dividedTiles,
                      );
                    }
                  }),
            ],
          );
        else
          return Center();
      },
    );
  }
}
