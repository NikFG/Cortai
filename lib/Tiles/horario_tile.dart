import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class HorarioTile extends StatelessWidget {
  final HorarioDados _dados;

  HorarioTile(this._dados);

  @override
  Widget build(BuildContext context) {
    List<String> _horario = _dados.horario.split(",");
    return InkWell(
      onTap: () {},
      child: Card(
          child: Padding(
        padding: EdgeInsets.only(left: 10, top: 8),
        child: Row(
          children: <Widget>[
            Image.network(
              "https://i.pinimg.com/originals/bb/5f/6b/bb5f6b2bed3a6ac41d9ba82fa5d47d36.jpg",
              height: 100,
              width: 75,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("SALÃO X"),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(_horario[0]),
                SizedBox(
                  height: 10,
                ),
                Text(_horario[1]),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {},
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
          ],
        ),
      )),
    );
    /* return ListTile(
      leading: Icon(Icons.access_time ),
      subtitle: Text(
        _dados.ocupado ? "Ocupado" : "Disponível",
        style: TextStyle(color: _dados.ocupado ? Colors.red : Colors.green),
      ),
      title: Text(_dados.horario),
      trailing: Icon(FontAwesome.chevron_right),
      onTap: () {
       _showDialog(context);
      },
    );*/
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
                  await FlushbarHelper.createSuccess(
                          message: "Aguarde confirmação do cabelereiro!!",
                          title: "Agendamento feito",
                          duration: Duration(seconds: 3))
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
