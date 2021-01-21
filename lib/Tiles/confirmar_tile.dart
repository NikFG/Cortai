import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Dados/cliente.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Widgets/custom_list_tile.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class ConfirmarTile extends StatefulWidget {
  final Horario horario;
  final ValueChanged<int> confirmadoChanged;

  ConfirmarTile(this.horario, {this.confirmadoChanged});

  @override
  _ConfirmarTileState createState() => _ConfirmarTileState();
}

class _ConfirmarTileState extends State<ConfirmarTile>
    with AutomaticKeepAliveClientMixin<ConfirmarTile> {
  bool confirmado;
  String valor;

  @override
  void initState() {
    super.initState();
    valor = widget.horario.servicos.first.valorFormatado();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Cliente cliente = widget.horario.cliente;
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) => CustomListTile(
        onTap: () => !widget.horario.confirmado
            ? _bottomSheetOpcoes(context, model.token)
            : !widget.horario.pago
                ? _dialogPago(context, model.token)
                : null,
        leading: null,
        title: Text(
          cliente.nome,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          "${widget.horario.servicos.first.descricao} $valor\n"
          "${widget.horario.data} -> ${widget.horario.hora}",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        trailing: widget.horario.confirmado ? _pago() : null,
      ),
    );
  }

  Widget _pago() {
    return Column(
      children: <Widget>[
        Text("Pago:"),
        widget.horario.pago
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

  _bottomSheetOpcoes(context, String token) async {
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
                          widget.horario.id, token,
                          onSuccess: () {}, onFail: () {}, context: context);
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
                                      widget.horario.id,
                                      token,
                                      onSuccess: () {},
                                      onFail: () {},
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Sim"),
                                ),
                              ],
                            )).then((value) => Navigator.of(context).pop());
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

  _dialogPago(context, String token) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("Confirma pagamento?"),
              content: Text(
                  "${widget.horario.data}:${widget.horario.hora}\nValor: $valor"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    HorarioControle.confirmaPagamento(widget.horario.id, token,
                        onSuccess: onSuccessPago, onFail: onFailPago);
                    Navigator.of(context).pop();
                  },
                  child: Text("Confirmar"),
                )
              ],
            ));
  }

  void onSuccess() async {
    widget.confirmadoChanged(widget.horario.id);
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

  @override
  bool get wantKeepAlive => true;
}
