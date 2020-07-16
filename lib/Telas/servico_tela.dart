import 'package:agendacabelo/Controle/servico_controle.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Dados/salao.dart';
import 'package:agendacabelo/Tiles/servico_tile.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Widgets/custom_appbar.dart';
import 'package:agendacabelo/Widgets/custom_appbar_expandida.dart';

class ServicoTela extends StatelessWidget {
  final Salao dados;
  final String distancia;

  ServicoTela({@required this.dados, @required this.distancia});

//TODO: mudar tela para não ficar tão fixa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
              backgroundColor: Colors.white,
              leading: Util.leadingScaffold(context),
              title: CustomAppbar(
                  child: Text(
                dados.nome,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                ),
                overflow: TextOverflow.fade,
              )),
              stretch: false,
              pinned: true,
              centerTitle: true,
              expandedHeight: 75.0,
              flexibleSpace: FlexibleSpaceBar(
                background: CustomAppbarExpandida(
                    nomeSalao: dados.nome,
                    enderecoSalao: dados.endereco,
                    menorValor: dados.menorValorServico,
                    maiorValor: dados.maiorValorServico,
                    distancia: distancia),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(color: Colors.green,height: 100,),
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
