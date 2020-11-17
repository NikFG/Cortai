import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Telas/dia_funcionamento_tela.dart';
import 'package:cortai/Telas/editar_horario_funcionamento.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/custom_button.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CadastroFuncionamentoTela extends StatefulWidget {
  final String salao;

  CadastroFuncionamentoTela(this.salao);

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
                                EditarFuncionamentoTela(widget.salao)));
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
                                        widget.salao,
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
            FutureBuilder<QuerySnapshot>(
              future: FuncionamentoControle.get(widget.salao).getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CustomShimmer(4);
                } else {
                  if (snapshot.data.documents.length == 0) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4),
                      child: CustomButton(
                        textoBotao: "Criar horários",
                        botaoHabilitado: true,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditarFuncionamentoTela(widget.salao))),
                      ),
                    );
                  }
                  var listaDocuments = snapshot.data.documents;
                  listaDocuments.sort((a, b) =>
                      Util.ordenarDiasSemana(a.documentID)
                          .compareTo(Util.ordenarDiasSemana(b.documentID)));
                  var listaRows = listaDocuments.map((doc) {
                    Funcionamento dados = Funcionamento();//Funcionamento.fromDocument(doc);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${dados.diaSemana}:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        Text(
                            "${dados.horarioAbertura} - ${dados.horarioFechamento}",
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DiaFuncionamentoTela(
                                      dados, widget.salao)));
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
                                                  dados.diaSemana, widget.salao,
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
                            child: Text(
                              "Remover",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList();
                  return Column(
                    children: listaRows,
                  );
                }
              },
            ),
          ],
        ),
      ),
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
