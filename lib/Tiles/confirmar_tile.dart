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
  Icon currentIcon = Icon(
    Icons.radio_button_unchecked,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return ListTile(
          leading: currentIcon,
          title: Text("${widget.snapshot.data['data']} - ${widget.snapshot.data['horario']}"),
          subtitle: Text(
            "Confirmar",
            style: TextStyle(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.start,
          ),
          trailing: Icon(FontAwesome.chevron_right),
          onLongPress: (){
            setState(() {
              currentIcon = Icon(Icons.radio_button_checked);
            });
          },
          onTap: () async {
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
                duration: Duration(milliseconds: 2));
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeTela()));
          },
        );
      },
    );
  }


}
