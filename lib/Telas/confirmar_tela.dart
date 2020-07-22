import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Dados/horario.dart';
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
                      .orderBy('data', descending: true)
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

                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          Horario horario = Horario.fromDocument(
                              snapshot.data.documents[index]);
                          return ConfirmarTile(horario);
                        },
                      );
                    }
                  }),
              StreamBuilder<QuerySnapshot>(
                  stream: HorarioControle.get()
                      .where('confirmado', isEqualTo: true)
                      .where('cabeleireiro', isEqualTo: model.dados.id)
                      .orderBy('data', descending: true)
                      .orderBy('horario')
                      //.orderBy('pago',descending: true)
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

                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          Horario horario = Horario.fromDocument(
                              snapshot.data.documents[index]);
                          return ConfirmarTile(horario);
                        },
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
