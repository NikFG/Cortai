import 'package:agendacabelo/Controle/cabeleireiro_controle.dart';
import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Dados/horario.dart';
import 'package:agendacabelo/Dados/login.dart';
import 'package:agendacabelo/Widgets/custom_list_tile.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ConfirmarTile extends StatefulWidget {
  final Horario horarioDados;

  ConfirmarTile(this.horarioDados);

  @override
  _ConfirmarTileState createState() => _ConfirmarTileState();
}

class _ConfirmarTileState extends State<ConfirmarTile> {
  bool confirmado;
  String valor;

  @override
  void initState() {
    super.initState();
    valor = widget.horarioDados.servicoDados.valorFormatado();
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: () => !widget.horarioDados.confirmado
          ? _bottomSheetOpcoes(context)
          : !widget.horarioDados.pago ? _dialogPago(context) : null,
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
      subtitle: Text(
        "${widget.horarioDados.servicoDados.descricao} $valor\n"
        "${widget.horarioDados.data} -> ${widget.horarioDados.horario}",
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      trailing: widget.horarioDados.confirmado ? _pago() : null,
    );
  }

  Widget _pago() {
    return Column(
      children: <Widget>[
        Text("Pago:"),
        widget.horarioDados.pago
            ? Icon(
                FontAwesome.check,
                color: Colors.green,
                size: 32,
              )
            : Icon(
                FontAwesome.times,
                color: Colors.red,
                size: 32,
              ),
      ],
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
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content:
                                  Text("Deseja realmente cancelar o horário?"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Não",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    confirmado = false;
                                    HorarioControle.cancelaAgendamento(
                                      widget.horarioDados,
                                      onSuccess: () {},
                                      onFail: () {},
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Sim"),
                                ),
                              ],
                            )).then((value) => Navigator.of(context).pop());
//                    confirmado = false;

//                    HorarioControle.cancelaAgendamento(
//                      widget.horarioDados,
//                      onSuccess: () {},
//                      onFail: () {},
//                    );
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

  _dialogPago(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("Confirma pagamento?"),
              content: Text(
                  "${widget.horarioDados.data}:${widget.horarioDados.horario}\nValor: $valor"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    HorarioControle.confirmaPagamento(widget.horarioDados.id,
                        onSuccess: onSuccessPago, onFail: onFailPago);
                    Navigator.of(context).pop();
                  },
                  child: Text("Confirmar"),
                )
              ],
            ));
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

  void onSuccessPago() async {
    await FlushbarHelper.createSuccess(
            message: "Pagamento confirmado com sucesso",
            duration: Duration(seconds: 2))
        .show(context);
  }

  void onFailPago() async {
    await FlushbarHelper.createError(
            message: "Houve algum erro ao confirmar pagamento",
            duration: Duration(seconds: 2))
        .show(context);
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
