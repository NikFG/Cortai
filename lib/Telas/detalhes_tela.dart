import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/horario.dart';
import 'package:agendacabelo/Dados/login.dart';
import 'package:agendacabelo/Dados/salao.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maps_launcher/maps_launcher.dart';

class DetalhesTela extends StatelessWidget {
  final Horario horario;
  final bool pago;
  final Login cabeleireiro;
  final Servico servico;

  DetalhesTela(
      {@required this.horario,
      this.servico,
      this.cabeleireiro,
      @required this.pago});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Detalhes",
          ),
          centerTitle: true,
          leading: Util.leadingScaffold(context)),
      body: FutureBuilder<DocumentSnapshot>(
        future: SalaoControle.get().document(cabeleireiro.salao).get(),
        //mudar para salao do horário
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Salao salao = Salao.fromDocument(snapshot.data);
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
                      pago
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
                                _cancelarDialog(context);
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
  }

  _cancelarDialog(BuildContext context) {
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
              await HorarioControle.cancelaAgendamento(horario,
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
