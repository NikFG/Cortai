import 'dart:convert';

import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/home_tela.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:scoped_model/scoped_model.dart';

class DetalhesTela extends StatelessWidget {
  final Horario horario;

  final Servico servico;

  DetalhesTela({@required this.horario, this.servico});

  @override
  Widget build(BuildContext context) {
    Cabeleireiro cabeleireiro = horario.cabeleireiro;
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
              title: Text(
                "Detalhes",
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
                    response.data.body)); //Salao.fromDocument(snapshot.data);
                return ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(salao.nome,
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w700)),
                          horario.pago
                              ? Text("Realizado às 12:28 - 16/07/2020",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ))
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                          Text("Agendamento ${horario.id}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              )),
                          ListTile(
                              leading: horario.confirmado
                                  ? Icon(
                                      FontAwesome.check_circle_o,
                                      color: Colors.green,
                                      size: 35,
                                    )
                                  : Icon(
                                      FontAwesome.times_circle_o,
                                      color: Colors.red,
                                      size: 35,
                                    ),
                              title: Text(cabeleireiro.nome),
                              trailing: Text(
                                  horario.confirmado
                                      ? "Confirmado"
                                      : "Não confirmado",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ))),
                          ListTile(
                            leading: Icon(FontAwesome.tag),
                            title: Text(servico.descricao,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            trailing: Text(
                                "R\$${servico.valor.toStringAsFixed(2).replaceAll('.', ',')}",
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text("Endereço",
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),
                              ),
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
                          Container(
                            child: Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "Cancelar Agendamento",
                                  ),
                                  onPressed: () {
                                    _cancelarDialog(context, model.token);
                                  },
                                ),
                                FlatButton(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                    "Ligar para salão",
                                  ),
                                  onPressed: () {
                                    Util.ligacaoTelefonica(salao.telefone);
                                  },
                                ),
                              ],
                            ),
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
          FlatButton(
            child: Text("Voltar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Confirmar"),
            onPressed: () async {
              await HorarioControle.cancelaAgendamento(horario.id, token,
                  onSuccess: onSuccess, onFail: onFail, clienteCancelou: true);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeTela()));
            },
          ),
        ],
      ),
    );
  }

  void onSuccess() async {}

  void onFail() async {}
}
