import 'dart:convert';

import 'package:cortai/Controle/servico_controle.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Tiles/gerencia_servico_tile.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/list_tile_custom.dart';
import 'package:cortai/Widgets/shimmer_custom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import 'criar_servico_tela.dart';

class GerenciarServicoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Editar Serviços"),
          ),
          body: FutureBuilder<http.Response>(
            future: http.get(ServicoControle.getServicoCabeleireiro(),
                headers: Util.token(model.token)),
            builder: (context, response) {
              if (!response.hasData) {
                return ShimmerCustom(5);
              } else {
                print(response.data.body);
                List<Widget> lista = [
                  ListTileCustom(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CriarServicoTela(titulo: "Criar serviço"))),
                    leading: Icon(
                      Icons.add_circle_outline,
                      size: 35,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text("Adicionar novo serviço"),
                  ),
                ];
                lista.addAll(json.decode(response.data.body).map<Widget>((doc) {
                  return GerenciaServicoTile(
                    dados: Servico.fromJsonApi(doc),
                  );
                }).toList());
                return ListView(children: lista);
              }
            },
          ),
        );
      },
    );
  }
}
