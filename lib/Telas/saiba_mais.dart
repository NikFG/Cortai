import 'package:agendacabelo/Controle/avaliacao_controle.dart';
import 'package:agendacabelo/Controle/funcionamento_controle.dart';
import 'package:agendacabelo/Dados/avaliacao.dart';
import 'package:agendacabelo/Dados/funcionamento.dart';
import 'package:agendacabelo/Dados/salao.dart';
import 'package:agendacabelo/Widgets/custom_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:maps_launcher/maps_launcher.dart';

class SaibaMaisTela extends StatelessWidget {
  final Salao salao;

  SaibaMaisTela(this.salao);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Saiba Mais",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            leading: Util.leadingScaffold(context, color: Colors.black),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "Salão",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                    child: Text(
                  "Avaliações",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ))
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(salao.nome,
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w700)),
                        Text("Horário de Funcionamento:",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            )),
                        FutureBuilder<QuerySnapshot>(
                          future: FuncionamentoControle.get(salao.id)
                              .getDocuments(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var listaFuncionamento =
                                  snapshot.data.documents.map((doc) {
                                return Funcionamento.fromDocument(doc);
                              }).toList();
                              listaFuncionamento.sort((a, b) =>
                                  Util.ordenarDiasSemana(a.diaSemana).compareTo(
                                      Util.ordenarDiasSemana(b.diaSemana)));
                              var listaWidgets =
                                  listaFuncionamento.map((dados) {
                                return Text(
                                    "${dados.diaSemana}: ${dados.horarioAbertura} as ${dados.horarioFechamento}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ));
                              }).toList();
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: listaWidgets);
                            }
                          },
                        ),
                        Text("Endereço:",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            )),
                        FlatButton(
                          onPressed: () async {
                            await MapsLauncher.launchCoordinates(
                                salao.latitude, salao.longitude);
                          },
                          child: Text("${salao.endereco}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              FutureBuilder<QuerySnapshot>(
                future: AvaliacaoControle.get()
                    .where('salao', isEqualTo: salao.id)
                    .orderBy('data', descending: true)
                    .orderBy('hora')
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        Avaliacao avaliacao = Avaliacao.fromDocument(
                            snapshot.data.documents[index]);
                        return CustomListTile(
                          onTap: () {},
                          leading: Text(avaliacao.avaliacao.toStringAsFixed(2)),
                          title: Text(avaliacao.descricao),
                        );
                      },
                    );
                  }
                },
              )
            ],
          )),
    );
  }
}
