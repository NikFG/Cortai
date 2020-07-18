import 'package:flutter/material.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SaibaMaisTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Saiba Mais",
          ),
          centerTitle: true,
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
                Text("Horário de Funcionamento:",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    )),
                Wrap(
                  spacing: 15.0, // gap between adjacent chips
                  runSpacing: 10.0,
                  children: <Widget>[
                    Text("Domingo",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("11:00 as 17:30,",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("Segunda",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("11:00 as 17:30,",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("Terça",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("11:00 as 17:30,",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("Quarta",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("11:00 as 17:30,",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                          Text("Quinta",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("11:00 as 17:30,",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                          Text("Sexta",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("11:00 as 17:30,",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                          Text("Sábado",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                    Text("11:00 as 17:30,",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        )),
                  ],
                ),
                Text("Endereço:",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    )),
                Text("Rua da Cobiça 129, Bairro Jacuí",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    )),
              ],
            ),
          ),
         Container(
                  child: Row(
                    children: <Widget>[
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
    );
  }
}

_cancelarDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Deseja mesmo cancelar este agendamento?"),
      content:
          Text("Caso cancele o agendamento, poderão ser cobradas taxas extras"),
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
