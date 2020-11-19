import 'dart:convert';

import 'package:cortai/Controle/servico_controle.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/saiba_mais.dart';
import 'package:cortai/Tiles/servico_tile.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cortai/Widgets/custom_appbar.dart';
import 'package:cortai/Widgets/custom_appbar_expandida.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class ServicoTela extends StatelessWidget {
  final Salao salao;
  final String distancia;

  ServicoTela({@required this.salao, @required this.distancia});

  @override
  Widget build(BuildContext context) {
    String media = salao.quantidadeAvaliacao > 0
        ? (salao.totalAvaliacao / salao.quantidadeAvaliacao).toStringAsFixed(1)
        : '0.0';
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
              backgroundColor: Colors.white,
              leading: Util.leadingScaffold(context),
              title: CustomAppbar(
                  child: Text(
                salao.nome,
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
                    nomeSalao: salao.nome,
                    enderecoSalao: salao.endereco,
                    menorValor: salao.menorValorServico,
                    maiorValor: salao.maiorValorServico,
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
                              builder: (context) => SaibaMaisTela(salao)));
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              salao.nome,
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
                                  builder: (context) => SaibaMaisTela(salao)));
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
                                      "R\$${salao.menorValorServico.toStringAsFixed(2)}"
                                      "~ R\$${salao.maiorValorServico.toStringAsFixed(2)}",
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
                                          media,
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
              ScopedModelDescendant<LoginModelo>(
                builder: (context, child, model) {
                  return FutureBuilder<http.Response>(
                    future: http.get(ServicoControle.getBySalao(this.salao.id),
                        headers: Util.token(model.token)),
                    builder: (context, response) {
                      if (!response.hasData) {
                        return CustomShimmer(4);
                      } else {
                        print(response.data.body);
                        List<dynamic> dados = json.decode(response.data.body);
                        var widgets = dados
                            .map((doc) => ServicoTile(
                                Servico.fromJson(doc), this.salao.nome))
                            .toList();
                        return Column(
                          children: widgets,
                        );
                      }
                    },
                  );
                },
              )
            ]),
          ),
        ],
      ),
    );
  }
}
