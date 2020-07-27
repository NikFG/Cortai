import 'package:agendacabelo/Controle/servico_controle.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Tiles/gerencia_servico_tile.dart';
import 'package:agendacabelo/Widgets/custom_list_tile.dart';
import 'package:agendacabelo/Widgets/custom_shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'criar_servico_tela.dart';

class GerenciarServicoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return FutureBuilder<QuerySnapshot>(
          future: ServicoControle.get()
              .where('salao', isEqualTo: model.dados.salao)
              .orderBy('ativo',descending: true)
              .orderBy('descricao')
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustomShimmer(5);
            } else {
              List<Widget> lista = [
                CustomListTile(
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
              lista.addAll(snapshot.data.documents.map((doc) {
                return GerenciaServicoTile(Servico.fromDocument(doc));
              }).toList());
              return ListView(children: lista);
            }
          },
        );
      },
    );
  }
}
