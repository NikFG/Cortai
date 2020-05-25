import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class CheckinTile extends StatelessWidget {
  final HorarioDados dados;

  CheckinTile(this.dados);

  @override
  Widget build(BuildContext context) {
    print(dados);
    return ListTile(
      onTap: () async {
        await Firestore.instance
            .collection('horarios')
            .document(dados.id)
            .updateData({'pago': true}).then((value) async {
          await FlushbarHelper.createSuccess(
                  message: "Confirmado o pagamento com sucesso!!",
                  duration: Duration(milliseconds: 1200))
              .show(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeTela()));
        }).catchError((e) async {
          print(e);
          await FlushbarHelper.createError(
                  message: "Houve algum erro ao confirmar",
                  duration: Duration(milliseconds: 1200))
              .show(context);
        });
      },
      title: FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance
            .collection('usuarios')
            .document(dados.cliente)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return Text('${snapshot.data['nome']} às ${dados.horario}');
          }
        },
      ),
    );
  }
}
