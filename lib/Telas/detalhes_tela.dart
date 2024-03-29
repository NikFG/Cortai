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
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:scoped_model/scoped_model.dart';

class DetalhesTela extends StatelessWidget {
  final Horario horario;

  final Servico? servico;

  DetalhesTela({required this.horario, this.servico});

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    Cabeleireiro cabeleireiro = horario.cabeleireiro!;
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
                          Text(salao.nome!,
                              style: TextStyle(
                                  fontSize: 28.0, fontWeight: FontWeight.w700)),
                          // horario.pago!
                          //     ? Text(
                          //         "Realizado às ${horario.hora} - ${horario.data}",
                          //         style: TextStyle(
                          //           fontSize: 12.0,
                          //         ))
                          //     : Container(
                          //         height: 0,
                          //         width: 0,
                          //       ),
                          Text("Código do agendamento: ${horario.id}",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                              )),
                          ListTile(
                            leading: Text("Cabeleireiro: "),
                            title: Text(cabeleireiro.nome),
                          ),
                          ListTile(
                            leading: Text("Confirmado: "),
                            title: status(horario.confirmado!),
                          ),
                          ListTile(
                            leading: Text("Pago: "),
                            title: status(horario.pago!),
                          ),
                          ListTile(
                            leading: Icon(FontAwesome.tag),
                            title: Text(servico!.descricao!,
                                style: TextStyle(
                                  fontSize: 12.0,
                                )),
                            trailing: Text(
                                "R\$${servico!.valor.toStringAsFixed(2).replaceAll('.', ',')}",
                                style: TextStyle(
                                  fontSize: 12.0,
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
                                      fontSize: 16.0,
                                    )),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await MapsLauncher.launchCoordinates(
                                      salao.latitude!, salao.longitude!);
                                },
                                child: Text("${salao.endereco}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor,
                                    )),
                              ),
                            ],
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: deviceInfo.size.width * 45 / 100,
                                  child: TextButton(
                                    child: Container(
                                      child: Text(
                                        "Ligar para salão",
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Util.ligacaoTelefonica(salao.telefone!);
                                    },
                                  ),
                                ),
                                !horario.pago!
                                    ? Container(
                                        width: deviceInfo.size.width * 45 / 100,
                                        child: TextButton(
                                          child: Container(
                                            child: Text(
                                              "Cancelar Agendamento",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            _cancelarDialog(
                                                context, model.token);
                                          },
                                        ))
                                    : Container(
                                        width: 0,
                                        height: 0,
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
                  onSuccess: onSuccess, onFail: onFail);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => IndexTela()));
            },
          ),
        ],
      ),
    );
  }

  Widget status(bool status) {
    if (status) {
      return Icon(
        Icons.check,
        color: Colors.green,
        size: 35,
      );
    }
    return Icon(
      FontAwesome5.times,
      color: Colors.red,
      size: 35,
    );
  }

  void onSuccess() async {}

  void onFail() async {}
}
