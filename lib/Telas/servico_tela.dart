import 'package:agendacabelo/Controle/servico_controle.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Dados/salao.dart';
import 'package:agendacabelo/Telas/saiba_mais.dart';
import 'package:agendacabelo/Tiles/servico_tile.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Widgets/custom_appbar.dart';
import 'package:agendacabelo/Widgets/custom_appbar_expandida.dart';
import 'package:flutter_icons/flutter_icons.dart';


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
                  fontSize: 20.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )),
              stretch: false,
              pinned: true,
              centerTitle: true,
              expandedHeight: 90.0,
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SaibaMaisTela(dados)));
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              dados.nome,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 22),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SaibaMaisTela(dados)));
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 8.0, right: 8.0),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                                // child: Icon(),

                                                ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                "$distancia",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(bottom: 8.0, left: 8.0),
                                    child: Text(
                                      "R\$19 "
                                      "~ R\$119",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(width: 2.0),
                                        Icon(Icons.star,
                                            color: Colors.amberAccent,
                                            size: 16.0),
                                        SizedBox(width: 5.0),
                                        Text(
                                          '4,5',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(FontAwesome.angle_right),
                                ])))
                  ],
                ),
              ),
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
