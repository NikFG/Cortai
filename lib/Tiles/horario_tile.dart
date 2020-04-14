import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HorarioTile extends StatelessWidget {
  final HorarioDados _dados;
  final String _cabelereiro_id;

  HorarioTile(this._dados, this._cabelereiro_id);

  @override
  Widget build(BuildContext context) {
    List<String> _horario = _dados.horario.split(",");

    return InkWell(
      onTap: () {},
      child: Card(
          child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: <Widget>[
            Image.network(
              "https://i.pinimg.com/originals/bb/5f/6b/bb5f6b2bed3a6ac41d9ba82fa5d47d36.jpg",
              height: 100,
              width: 75,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(_horario[0]),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_horario[1]),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () async {
                          await _showDialog(context);
                        },
                        child: Text("Confirmar"),
                        color: Colors.lightGreen[400],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Mais informações"),
                        color: Colors.blueGrey,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirma o preço x para o horario y?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Fechar"),
              ),
              FlatButton(
                onPressed: () async {
                  await Firestore.instance
                      .collection("cabelereiros")
                      .document(this._cabelereiro_id)
                      .collection("horarios")
                      .add(_dados.toMap());
                  await FlushbarHelper.createSuccess(
                          message: "Aguarde confirmação do cabelereiro!!",
                          title: "Agendamento feito",
                          duration: Duration(milliseconds: 1500))
                      .show(context);

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeTela()));
                },
                child: Text("Confirmar"),
              )
            ],
          );
        });
  }


}
