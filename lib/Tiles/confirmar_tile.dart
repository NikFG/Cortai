import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class ConfirmarTile extends StatefulWidget {
  final DocumentSnapshot snapshot;

  const ConfirmarTile(this.snapshot);

  @override
  _ConfirmarTileState createState() => _ConfirmarTileState();
}

class _ConfirmarTileState extends State<ConfirmarTile> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Dismissible(
          key: Key(widget.snapshot.documentID),
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
                alignment: Alignment(0.9, -0),
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                )),
          ),
          onDismissed: (direction) async {
            switch (direction) {
              case DismissDirection.vertical:
                // TODO: Handle this case.
                break;
              case DismissDirection.horizontal:
                // TODO: Handle this case.
                break;
              case DismissDirection.endToStart:
                await Firestore.instance
                    .collection("usuarios")
                    .document(model.dados['uid'])
                    .collection("horarios")
                    .document(widget.snapshot.documentID)
                    .updateData({
                  "ocupado": false,
                  "cliente": FieldValue.delete(),
                  "preco": FieldValue.delete(),
                });
                FlushbarHelper.createError(
                        message: "Horário cancelado com sucesso",
                        duration: Duration(milliseconds: 1500))
                    .show(context);
                break;
              case DismissDirection.startToEnd:
                await Firestore.instance
                    .collection("usuarios")
                    .document(model.dados['uid'])
                    .collection("horarios")
                    .document(widget.snapshot.documentID)
                    .updateData({
                  "confirmado": true,
                });
                FlushbarHelper.createSuccess(
                        message: "Horário confirmado com sucesso",
                        duration: Duration(milliseconds: 1500))
                    .show(context);
                break;
              case DismissDirection.up:
                // TODO: Handle this case.
                break;
              case DismissDirection.down:
                // TODO: Handle this case.
                break;
            }
          },
          child: ListTile(
            title: Text(
                "${widget.snapshot.data['data']} - ${widget.snapshot.data['horario']}"),
            subtitle: Text(
              "Confirmar",
              style: TextStyle(color: Theme.of(context).primaryColor),
              textAlign: TextAlign.start,
            ),
            trailing: Icon(FontAwesome.chevron_right),
            /* onTap: () async {
              await Firestore.instance
                  .collection("usuarios")
                  .document(model.dados['uid'])
                  .collection("horarios")
                  .document(widget.snapshot.documentID)
                  .updateData({
                "confirmado": true,
              });
              FlushbarHelper.createSuccess(
                  message: "Horário confirmado com sucesso",
                  duration: Duration(milliseconds: 1500));
            },*/
          ),
        );
      },
    );
  }
}
