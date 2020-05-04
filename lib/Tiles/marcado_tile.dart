import 'package:agendacabelo/Dados/cabelereiro_dados.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarcadoTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  MarcadoTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    HorarioDados horario = HorarioDados.fromDocument(this.snapshot);

    return ListTile(
      onTap: () {
        cancelarDialog(context);
      },
      title: FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance
            .collection('usuarios')
            .document(horario.cabelereiro)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            CabelereiroDados dados =
                CabelereiroDados.fromDocument(snapshot.data);
            return Text(dados.nome);
          }
        },
      ),
      subtitle: Text(horario.horario),
      leading: horario.confirmado
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : Icon(
              Icons.clear,
              color: Colors.red,
            ),
    );
  }

  cancelarDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Deseja mesmo cancelar este agendamento?"),
        content: Text(
            "Caso cancele o agendamento, poderão ser cobradas taxas extras"),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancelar"),
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
}
