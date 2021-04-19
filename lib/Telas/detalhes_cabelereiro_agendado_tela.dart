import 'dart:convert';

import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/index_tela.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class DetalhesCabelereiroTela extends StatelessWidget {
  final Horario horario;

  final Servico? servico;

  DetalhesCabelereiroTela({required this.horario, this.servico});

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    Cabeleireiro cabeleireiro = horario.cabeleireiro!;
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
              title: Text(
                "Detalhes do serviço",
              ),
              centerTitle: true,
              leading: Util.leadingScaffold(context)),
          body: FutureBuilder<http.Response>(
            future: http.get(SalaoControle.show(cabeleireiro.salaoId),
                headers: Util.token(model.token)),
            //mudar para salao do horário
            builder: (context, response) {
              if (!response.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                Salao salao = Salao.fromJsonApiDados(jsonDecode(
                    response.data!.body)); //Salao.fromDocument(snapshot.data);
                return ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 10, left: 10),
                            child: Text(salao.nome!,
                                style: TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.w700)),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 10, left: 10),
                            child: Text(
                                "Realizado às ${horario.hora} - ${horario.data}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                )),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 10, left: 10),
                            child: Text("Agendamento ${horario.id}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 10, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text("Nome do Cliente:",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),
                                Container(
                                  child: Text(
                                    "Fulano",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 10, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text("Realizado por:",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),
                                Container(
                                  child: Text(
                                    "Nome do fulano",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(FontAwesome.tag),
                            title: Text(servico!.descricao!,
                                style: TextStyle(
                                  fontSize: 14.0,
                                )),
                            trailing: Text(
                                "R\$${servico!.valor.toStringAsFixed(2).replaceAll('.', ',')}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }

  _cancelarDialog(BuildContext context, String token) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Deseja mesmo cancelar este agendamento?"),
        content: Text(
            "Caso cancele o agendamento, poderão ser cobradas taxas extras"),
        actions: <Widget>[
          TextButton(
            child: Text("Voltar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Confirmar"),
            onPressed: () async {
              await HorarioControle.cancelaAgendamento(horario.id!, token,
                  onSuccess: onSuccess, onFail: onFail, clienteCancelou: true);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => IndexTela()));
            },
          ),
        ],
      ),
    );
  }

  void onSuccess() async {}

  void onFail() async {}
}
