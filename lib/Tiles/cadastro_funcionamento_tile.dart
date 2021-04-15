import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Telas/dia_funcionamento_tela.dart';
import 'package:cortai/Widgets/list_tile_custom.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class CadastroFuncionamentoTile extends StatefulWidget {
  final Funcionamento funcionamento;
  final String token;

  CadastroFuncionamentoTile(this.funcionamento, this.token);

  @override
  _CadastroFuncionamentoTileState createState() =>
      _CadastroFuncionamentoTileState();
}

class _CadastroFuncionamentoTileState extends State<CadastroFuncionamentoTile> {
  @override
  Widget build(BuildContext context) {
    return ListTileCustom(
        leading: null,
        title: Text("${widget.funcionamento.diaSemana}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        subtitle: Text(
            "${widget.funcionamento.horarioAbertura} - ${widget.funcionamento.horarioFechamento}",
            style: TextStyle(
              fontSize: 16,
            )),
        onTap: () {
          _bottomSheetOpcoes(context, widget.funcionamento, widget.token);
        });
  }

  _bottomSheetOpcoes(context, Funcionamento dados, String token) async {
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
                    title: Text('Editar Horário'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DiaFuncionamentoTela(dados, token)));
                    }),
                ListTile(
                    leading: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                    title: Text('Remover Horário'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(
                                    "Deseja realmente remover este horário do salão?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      await FuncionamentoControle.delete(
                                          dados.id!, token,
                                          onSuccess: onSuccessDeletado,
                                          onFail: onFailDeletado);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Sim"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Não"),
                                  ),
                                ],
                              )).then((value) => Navigator.of(context).pop());
                    }),
              ],
            ),
          );
        });
    setState(() {});
  }

  void onSuccessDeletado() async {
    await FlushbarHelper.createSuccess(message: "Deletado com sucesso")
        .show(context);
    Navigator.of(context).pop();
  }

  void onFailDeletado() async {
    await FlushbarHelper.createError(
            message: "Houve um erro ao deletar horário")
        .show(context);
    Navigator.of(context).pop();
  }
}
