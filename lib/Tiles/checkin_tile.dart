import 'package:agendacabelo/Controle/forma_pagamento_controle.dart';
import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Dados/forma_pagamento_dados.dart';
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
    return ListTile(
      onTap: () async {
        await HorarioControle.get()
            .document(dados.id)
            .updateData({'pago': true}).then((value) async {
          await FlushbarHelper.createSuccess(
                  message: "Confirmado o pagamento com sucesso!!",
                  duration: Duration(milliseconds: 1200))
              .show(context);
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
            return Center();
          } else {
            return Text(
                '${snapshot.data['nome']} ${dados.data} às ${dados.horario}');
          }
        },
      ),
      subtitle: dados.formaPagamento != null
          ? FutureBuilder<DocumentSnapshot>(
              future: FormaPagamentoControle.get()
                  .document(dados.formaPagamento)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center();
                } else {
                  var dados = FormaPagamentoDados.fromDocument(snapshot.data);
                  return Text(
                      "Será pago da seguinte forma: ${dados.descricao}");
                }
              },
            )
          : Container(
              width: 0,
              height: 0,
            ),
    );
  }
}
