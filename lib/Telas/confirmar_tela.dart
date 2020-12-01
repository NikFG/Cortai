import 'dart:convert';

import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Tiles/confirmar_tile.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

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
              FutureBuilder<http.Response>(
                  future: http.get(
                      HorarioControle.getCabeleireiro('cabeleireiro', 0),
                      headers: Util.token(model.token)),
                  builder: (context, response) {
                    if (!response.hasData) {
                      return CustomShimmer(4);
                    } else {
                      if (response.data.body == '[]') {
                        return Center(
                          child: Text("Não há agendamentos para confirmar"),
                        );
                      }
                      List<Horario> listaConfirmar =
                          jsonDecode(response.data.body)
                              .map<Horario>((h) => Horario.fromJson(h))
                              .toList();
                      return ListView.builder(
                        itemCount: listaConfirmar.length,
                        itemBuilder: (context, index) {
                          Horario horario = listaConfirmar[index];

                          return ConfirmarTile(horario);
                        },
                      );
                    }
                  }),
              FutureBuilder<http.Response>(
                  future: http.get(
                      HorarioControle.getCabeleireiro('cabeleireiro', 1),
                      headers: Util.token(model.token)),
                  builder: (context, response) {
                    if (!response.hasData) {
                      return CustomShimmer(4);
                    } else {
                      if (response.data.body == '[]') {
                        return Center(
                          child: Text("Não há agendamentos para confirmar"),
                        );
                      }
                      var listaConfirmar = jsonDecode(response.data.body)
                          .map<Horario>((h) => Horario.fromJson(h))
                          .toList();
                      return ListView.builder(
                        itemCount: listaConfirmar.length,
                        itemBuilder: (context, index) {
                          Horario horario = listaConfirmar[index];
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
