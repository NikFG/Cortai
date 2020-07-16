import 'package:agendacabelo/Controle/servico_controle.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Dados/salao.dart';
import 'package:agendacabelo/Tiles/servico_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Widgets/servico_fixed_appbar.dart';
import 'package:agendacabelo/Widgets/servico_flexible_appbar.dart';

class ServicoTela extends StatelessWidget {
  final Salao dados;
  final String distancia;

  ServicoTela(
      {@required this.dados,
      @required this.distancia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
              title: ServicoFixedAppbar(
                  child: Text(
                dados.nome,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                ),
                overflow: TextOverflow.fade,
              )),
              stretch: true,
              pinned: true,
              centerTitle: true,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                background: ServicoFlexibleAppBar(
                    nomeSalao: dados.nome,
                    enderecoSalao: dados.endereco,
                    menorValor: dados.menorValorServico,
                    maiorValor: dados.maiorValorServico,
                    distancia: distancia),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              FutureBuilder<QuerySnapshot>(
                future: ServicoControle.get()
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
                        .map((doc) =>
                            ServicoTile(Servico.fromDocument(doc), dados.nome))
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
