import 'package:agendacabelo/Controle/servico_controle.dart';
import 'package:agendacabelo/Dados/servico_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Tiles/gerencia_servico_tile.dart';
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
              .where('salao', isEqualTo: model.getSalao())
              .orderBy('descricao')
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Widget> lista = [
                ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CriarServicoTela(titulo: "Criar serviço"))),
                  leading: Icon(Icons.add),
                  title: Text("Adicionar novo serviço"),
                )
              ];
              lista.addAll(ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((doc) {
                    return GerenciaServicoTile(ServicoDados.fromDocument(doc));
                  }).toList(),
                  color: Colors.grey[500],
                  context: context));
              return ListView(children: lista);
            }
          },
        );
      },
    );
  }
}
