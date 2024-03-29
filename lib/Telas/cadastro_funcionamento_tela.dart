import 'dart:convert';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/editar_horario_funcionamento.dart';
import 'package:cortai/Tiles/cadastro_funcionamento_tile.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:cortai/Widgets/shimmer_custom.dart';
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
    MediaQueryData deviceInfo = MediaQuery.of(context);
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
                    child: TextButton(
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
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(
                                      "Deseja realmente remover todos os horários do salão?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        FuncionamentoControle.deleteAll(
                                            model.token,
                                            onSuccess: onSuccessDeletado,
                                            onFail: onFailDeletado);
                                        setState(() {});
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
              shrinkWrap: true,
              physics: ScrollPhysics(),
              padding: EdgeInsets.all(5),
              children: <Widget>[
                FutureBuilder<http.Response>(
                  future: http.get(
                      FuncionamentoControle.get(model.dados!.salaoId!),
                      headers: Util.token(model.token)),
                  builder: (context, response) {
                    if (!response.hasData) {
                      return ShimmerCustom(4);
                    } else {
                      if (response.data!.statusCode == 404) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 4),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 10,
                                child: Text(
                                    "Parece que você ainda não definiu nenhum horário de funcionamento :/"),
                              ),
                              SizedBox(
                                height: deviceInfo.size.height * 45 / 100,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 2.0),
                                child: Container(
                                  child: ButtonCustom(
                                    textoBotao: "Criar horários",
                                    botaoHabilitado: true,
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditarFuncionamentoTela())),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      List<Funcionamento> listaFuncionamento = json
                          .decode(response.data!.body)
                          .map<Funcionamento>((f) => Funcionamento.fromJson(f))
                          .toList();
                      listaFuncionamento.sort((a, b) =>
                          Util.ordenarDiasSemana(a.diaSemana)!
                              .compareTo(Util.ordenarDiasSemana(b.diaSemana)!));
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: listaFuncionamento.length,
                        itemBuilder: (context, index) {
                          var dados = listaFuncionamento[index];
                          return CadastroFuncionamentoTile(dados, model.token);
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
