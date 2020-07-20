import 'package:agendacabelo/Controle/cabeleireiro_controle.dart';
import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Controle/servico_controle.dart';

import 'package:agendacabelo/Dados/horario.dart';
import 'package:agendacabelo/Dados/login.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Widgets/custom_list_tile.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class ConfirmarTile extends StatefulWidget {
  final Horario horarioDados;
  final bool aConfirmar;

  ConfirmarTile(this.horarioDados, this.aConfirmar);

  @override
  _ConfirmarTileState createState() => _ConfirmarTileState();
}

class _ConfirmarTileState extends State<ConfirmarTile> {
  bool confirmado;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: () => widget.aConfirmar ? _bottomSheetOpcoes(context) : null,
      leading: null,
      title: FutureBuilder(
        future: CabeleireiroControle.get()
            .document(widget.horarioDados.cliente)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center();
          } else {
            Login cliente = Login.fromDocument(snapshot.data);
            return Text(
              cliente.nome,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            );
          }
        },
      ),
      subtitle: FutureBuilder(
        future:
            ServicoControle.get().document(widget.horarioDados.servico).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center();
          } else {
            Servico servicoDados = Servico.fromDocument(snapshot.data);
            return Text(
              "${servicoDados.descricao}\n"
              "${widget.horarioDados.data} -> ${widget.horarioDados.horario}",
              style: TextStyle(
                fontSize: 15,
              ),
            );
          }
        },
      ),
    );
  }

  _bottomSheetOpcoes(context) async {
    await showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text('Confirmar Horário'),
                    onTap: () {
                      confirmado = true;
                      Navigator.of(context).pop();
                      HorarioControle.confirmaAgendamento(
                          widget.horarioDados.id,
                          onSuccess: () {},
                          onFail: () {},
                          context: context);
                    }),
                ListTile(
                  leading: Icon(Icons.remove_circle, color: Colors.red),
                  title: Text('Cancelar Horário'),
                  onTap: () {
                    confirmado = false;
                    Navigator.of(context).pop();
                    HorarioControle.cancelaAgendamento(
                      widget.horarioDados,
                      onSuccess: () {},
                      onFail: () {},
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text('Voltar'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }).then((value) {
      if (confirmado != null) if (confirmado)
        onSuccess();
      else
        onSuccessCancelar();
    });
    setState(() {});
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
        .show(Scaffold.of(context).context);
  }

  void onSuccessCancelar() async {
    await FlushbarHelper.createError(
            message: "Horário cancelado com sucesso",
            duration: Duration(seconds: 2))
        .show(Scaffold.of(context).context);
  }

  void onFailCancelar() async {
    await FlushbarHelper.createError(
            message: "Houve algum erro ao cancelar o horário",
            duration: Duration(seconds: 2))
        .show(Scaffold.of(context).context);
  }
}
