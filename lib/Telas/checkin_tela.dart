import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Tiles/checkin_tile.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CheckinTela extends StatefulWidget {
  @override
  _CheckinTelaState createState() => _CheckinTelaState();
}

class _CheckinTelaState extends State<CheckinTela> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Checkin de cliente nomeLegal"),
              leading: Util.leadingScaffold(context),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: HorarioControle.get()
                  .where('cabeleireiro', isEqualTo: model.dados.id)
                  .where('confirmado', isEqualTo: true)
                  .where('pago', isEqualTo: false)
                  .orderBy('cliente')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var dividedTiles = ListTile.divideTiles(
                          tiles: snapshot.data.documents.map((doc) {
                            return CheckinTile(
                                HorarioDados.fromDocument(doc));
                          }).toList(),
                          color: Colors.grey[500],
                          context: context)
                      .toList();
                  return ListView(
                    children: dividedTiles,
                  );
                }
              },
            ));
      },
    );
  }
}
