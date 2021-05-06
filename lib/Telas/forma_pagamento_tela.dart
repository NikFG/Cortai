import 'dart:convert';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cortai/Controle/forma_pagamento_controle.dart';
import 'package:cortai/Dados/forma_pagamento.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/index_tela.dart';
import 'package:cortai/Tiles/forma_pagamento_tile.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class FormaPagamentoTela extends StatefulWidget {
  FormaPagamentoTela();

  @override
  _FormaPagamentoTelaState createState() => _FormaPagamentoTelaState();
}

class _FormaPagamentoTelaState extends State<FormaPagamentoTela> {
  var _formKey = GlobalKey<FormState>();
  List<int> formasIds = [];
  bool _botaoHabilitado = true;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            leading: Util.leadingScaffold(context),
            title: Text("Formas de pagamento"),
            centerTitle: true,
          ),
          body: Form(
              key: _formKey,
              child: FutureBuilder<http.Response>(
                future: http.get(FormaPagamentoControle.get(),
                    headers: Util.token(model.token)),
                builder: (context, response) {
                  if (!response.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<dynamic> dados = jsonDecode(response.data!.body);

                  return ListView(
                    children: [
                      ListView.builder(
                          itemCount: dados.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            FormaPagamento pagamento =
                                FormaPagamento.fromJson(dados[index]);
                            return FormaPagamentoTile(
                              pagamento: pagamento,
                              salaoId: model.dados!.salaoId!,
                              onFormasChanged: (value) {
                                if (value.checked) {
                                  formasIds.add(value.id);
                                } else {
                                  formasIds.remove(value.id);
                                }
                              },
                            );
                          }),
                      ButtonCustom(
                          textoBotao: "Confirmar",
                          botaoHabilitado: _botaoHabilitado,
                          onPressed: () async {
                            if (this.formasIds.isNotEmpty) {
                              setState(() {
                                _botaoHabilitado = false;
                              });
                              await FormaPagamentoControle.store(
                                  formasIds, model.token,
                                  onSuccess: onSuccess, onFail: onFail);
                            }
                          })
                    ],
                  );
                },
              )),
        );
      },
    );
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
      message: "Formas de pagamento atualizadas com sucesso",
    ).show(context);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => IndexTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(
            title:
                'Houve algum erro ao atualizar as formas de pagamento\nTente novamente!!',
            message: "")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
