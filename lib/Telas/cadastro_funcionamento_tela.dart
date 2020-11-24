import 'dart:convert';

import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/dia_funcionamento_tela.dart';
import 'package:cortai/Telas/editar_horario_funcionamento.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/custom_button.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class CadastroFuncionamentoTela extends StatefulWidget {
  CadastroFuncionamentoTela();

  @override
  _CadastroFuncionamentoTelaState createState() =>
      _CadastroFuncionamentoTelaState();
}

class _CadastroFuncionamentoTelaState extends State<CadastroFuncionamentoTela> {
  //TODO: estilizar
  var _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Funcionamento'),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditarFuncionamentoTela()));
                      },
                      child: Text("Editar todos"),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: FlatButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(
                                      "Deseja realmente remover todos os horários do salão?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        FuncionamentoControle.deleteAll(
                                            model.token,
                                            onSuccess: onSuccessDeletado,
                                            onFail: onFailDeletado);
                                        setState(() {});
                                      },
                                      child: Text("Sim"),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Não"),
                                    ),
                                  ],
                                ));
                      },
                      child: Text("Remover todos"),
                    ),
                  )
                ],
              )
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(5),
              children: <Widget>[
                FutureBuilder<http.Response>(
                  future: http.get(
                      FuncionamentoControle.get(model.dados.salao_id),
                      headers: Util.token(model.token)),
                  builder: (context, response) {
                    if (!response.hasData) {
                      return CustomShimmer(4);
                    } else {
                      print(response.data.body == '[]');
                      if (response.data.body == '[]') {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 4),
                          child: CustomButton(
                            textoBotao: "Criar horários",
                            botaoHabilitado: true,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditarFuncionamentoTela())),
                          ),
                        );
                      }
                      List<Funcionamento> listaFuncionamento = json
                          .decode(response.data.body)
                          .map<Funcionamento>((f) => Funcionamento.fromJson(f))
                          .toList();
                      listaFuncionamento.sort((a, b) =>
                          Util.ordenarDiasSemana(a.diaSemana)
                              .compareTo(Util.ordenarDiasSemana(b.diaSemana)));
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFuncionamento.length,
                        itemBuilder: (context, index) {
                          var dados = listaFuncionamento[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("${dados.diaSemana}:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                  "${dados.horarioAbertura} - ${dados.horarioFechamento}",
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                              Expanded(
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DiaFuncionamentoTela(
                                                    dados, model.token)));
                                  },
                                  child: Text(
                                    "Editar",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FlatButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              content: Text(
                                                  "Deseja realmente remover este horário do salão?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    FuncionamentoControle.delete(
                                                        dados.id,
                                                        model.token,
                                                        onSuccess:
                                                            onSuccessDeletado,
                                                        onFail: onFailDeletado);
                                                    setState(() {});
                                                  },
                                                  child: Text("Sim"),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Não"),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Text(
                                    "Remover",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
