import 'dart:convert';

import 'package:agendacabelo/Dados/horario.dart';
import 'package:agendacabelo/Dados/login.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Tiles/agendado_tile.dart';
import 'package:agendacabelo/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class AgendadoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(builder: (context, child, model) {
      if (model.dados != null) {
        String url =
            'https://us-central1-cortai-349b0.cloudfunctions.net/getAgendados'
            '?clienteId=${model.dados.id}&pago=';
        return TabBarView(
          children: <Widget>[
            FutureBuilder<http.Response>(
              future: http.get(url + 'false'),
              builder: (context, response) {
                if (!response.hasData) {
                  return CustomShimmer(4);
                } else {
                  List<dynamic> dados = json.decode(response.data.body);
                  var widgets = dados
                      .map((dado) => AgendadoTile(
                            horario: Horario.fromJson(dado),
                            servico: Servico.fromHorarioJson(dado),
                            cabeleireiro: Login.fromHorarioJson(dado),
                            pago: false,
                          ))
                      .toList();
                  return ListView(children: widgets);
                }
              },
            ),
            FutureBuilder<http.Response>(
              future: http.get(url + 'true'),
              builder: (context, response) {
                if (!response.hasData) {
                  return CustomShimmer(4);
                } else {
                  List<dynamic> dados = json.decode(response.data.body);
                  var widgets = dados
                      .map((dado) => AgendadoTile(
                            horario: Horario.fromJson(dado),
                            servico: Servico.fromHorarioJson(dado),
                            cabeleireiro: Login.fromHorarioJson(dado),
                            pago: true,
                          ))
                      .toList();
                  return ListView(children: widgets);
                }
              },
            ),
          ],
        );
      } else {
        return Center();
      }
    });
  }

/*ListView lista(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    var dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.documents.map((doc) {
              return MarcadoTile(HorarioDados.fromDocument(doc));
            }).toList(),
            color: Colors.grey[500],
            context: context)
        .toList();
    return ListView(children: dividedTiles);
  }*/
}
