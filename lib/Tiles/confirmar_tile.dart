import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class ConfirmarTile extends StatefulWidget {
  final HorarioDados dados;

  const ConfirmarTile(this.dados);

  @override
  _ConfirmarTileState createState() => _ConfirmarTileState();
}

class _ConfirmarTileState extends State<ConfirmarTile> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, left:20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Tela de Confirmação",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Dismissible(
                key: Key(widget.dados.id),
                background: Container(
                  width: 20,
                  color: Colors.green,
                  child: Align(
                      alignment: Alignment(-0.9, 0),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      )),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Align(
                      alignment: Alignment(0.9, 0),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                ),
                onDismissed: (direction) async {
                  switch (direction) {
                    case DismissDirection.endToStart:
                      await Firestore.instance
                          .collection('horariosExcluidos')
                          .add(widget.dados.toMap());
                      await HorarioControle.delete(widget.dados.id).then(
                          (value) async => await FlushbarHelper.createError(
                                  message: "Horário cancelado com sucesso",
                                  duration: Duration(seconds: 2))
                              .show(context));

                      break;
                    case DismissDirection.startToEnd:
                      HorarioControle.confirma(widget.dados.id,
                          onSuccess: onSuccess, onFail: onFail);

                      break;
                    case DismissDirection.vertical:
                    case DismissDirection.horizontal:
                    case DismissDirection.up:
                    case DismissDirection.down:
                      break;
                  }
                },
                child: ListTile(
                  title: Text("Salao bom demais"),
                  subtitle: Text(
                    "${widget.dados.data} - ${widget.dados.horario}",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.start,
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                    backgroundColor: Colors.transparent,
                  ),
                  trailing: Icon(FontAwesome.chevron_right),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Horário confirmado com sucesso",
            duration: Duration(seconds: 2))
        .show(context);
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Houve algum erro ao confirmar o horário",
            duration: Duration(seconds: 2))
        .show(context);
  }
}
