import 'dart:convert';

import 'package:cortai/Controle/avaliacao_controle.dart';
import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/avaliacao.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/list_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SaibaMaisTela extends StatelessWidget {
  final Salao salao;

  SaibaMaisTela(this.salao);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
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
                            Text(salao.nome!,
                                style: TextStyle(
                                    fontSize: 24.0.sp,
                                    fontWeight: FontWeight.w700)),
                            Text("Horário de Funcionamento:",
                                style: TextStyle(
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                )),
                            FutureBuilder<http.Response>(
                              future: http.get(
                                  FuncionamentoControle.get(salao.id!),
                                  headers: Util.token(model.token)),
                              builder: (context, response) {
                                if (!response.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  List<Funcionamento> listaFuncionamento =
                                      jsonDecode(response.data!.body)
                                          .map<Funcionamento>(
                                              (f) => Funcionamento.fromJson(f))
                                          .toList();

                                  listaFuncionamento.sort((a, b) =>
                                      Util.ordenarDiasSemana(a.diaSemana)!
                                          .compareTo(Util.ordenarDiasSemana(
                                              b.diaSemana)!));
                                  var listaWidgets =
                                      listaFuncionamento.map((dados) {
                                    return Text(
                                        "${dados.diaSemana}: ${dados.horarioAbertura} as ${dados.horarioFechamento}",
                                        style: TextStyle(
                                          fontSize: 16.0.sp,
                                        ));
                                  }).toList();
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: listaWidgets);
                                }
                              },
                            ),
                            Text("Endereço:",
                                style: TextStyle(
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                )),
                            TextButton(
                              onPressed: () async {
                                await MapsLauncher.launchCoordinates(
                                    salao.latitude!, salao.longitude!);
                              },
                              child: Text("${salao.endereco}",
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<http.Response>(
                    future: http.get(AvaliacaoControle.get(salao.id!),
                        headers: Util.token(model.token)),
                    builder: (context, response) {
                      if (!response.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List<Avaliacao> avaliacoes =
                            jsonDecode(response.data!.body)
                                .map<Avaliacao>((a) => Avaliacao.fromJson(a))
                                .toList();
                        return ListView.builder(
                          itemCount: avaliacoes.length,
                          itemBuilder: (context, index) {
                            Avaliacao avaliacao = avaliacoes[index];
                            return ListTileCustom(
                              onTap: () {},
                              leading: Text(avaliacao.valor.toStringAsFixed(2)),
                              title: Text(avaliacao.observacao),
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              )),
        );
      },
    );
  }
}
