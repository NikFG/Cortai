import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Telas/forma_pagamento_tela.dart';
import 'package:agendacabelo/Tiles/servico_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/nikol/AndroidStudioProjects/agenda_cabelo/lib/Widgets/servico_flexible_appbar.dart';
import 'file:///C:/Users/nikol/AndroidStudioProjects/agenda_cabelo/lib/Widgets/servico_fixed_appbar.dart';

class ServicoTela extends StatelessWidget {
  final SalaoDados dados;
  final double menorValor;
  final double maiorValor;
  final String distancia;

  ServicoTela(
      {@required this.dados,
      @required this.menorValor,
      @required this.maiorValor,
      @required this.distancia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
              title: FixedAppBar(dados.nome),
              stretch: true,
              pinned: true,
              onStretchTrigger: () {
                return;
              },
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                background: ServicoFlexibleAppBar(
                    nomeSalao: dados.nome,
                    menorValor: menorValor,
                    maiorValor: maiorValor,
                    distancia: distancia),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection('servicos')
                    .where('salao', isEqualTo: dados.id)
                    .orderBy('descricao')
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var widgets = snapshot.data.documents
                        .map((doc) => ServicoTile(PrecoDados.fromDocument(doc)))
                        .toList();
                    return Column(
                      children: widgets,
                    );
                  }
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
