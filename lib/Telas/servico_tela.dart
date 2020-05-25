import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Tiles/servico_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Widgets/servico_fixed_appbar.dart';
import 'package:agendacabelo/Widgets/servico_flexible_appbar.dart';

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
              title: servico_fixed_appbar(
                child: Text(
                  dados.nome,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                  ),
                  overflow: TextOverflow.fade,
                )
              ),
              stretch: true,
              pinned: true,
              centerTitle: true,
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
