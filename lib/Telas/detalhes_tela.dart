import 'package:flutter/material.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DetalhesTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Detalhes",
          ),
          centerTitle: false,
          leading: Util.leadingScaffold(context)),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Seu zé Barber",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        fontWeight: FontWeight.w700)),
                Text("Realizado às 12:28 - 16/07/2020",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    )),
                Text("Agendamento 12",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )),
                ListTile(
                    leading:
                        Icon(FontAwesome.check_circle, color: Colors.green),
                    title: Text("Mateus"),
                    trailing: Text("Confirmado",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ))),
                ListTile(
                  leading: Icon(FontAwesome.tag),
                  title: Text("Corte Massa",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      )),
                  trailing: Text("R\$19,90",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      )),
                ),
                Text("Endereço: \n Rua da cobiça 117, Bairro inferno",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    )),
                Container(
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text("Cancelar Agendamento"),
                        onPressed: () => {_cancelarDialog(context)},
                      ),
                      FlatButton(
                        child: Text("Ligar para salão"),
                        onPressed: () {
                          print("CANCELEI HAHA 20MIL PRA EUU");
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
            onPressed: () {
              print("CANCELEI HAHA 20MIL PRA EUU");
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }