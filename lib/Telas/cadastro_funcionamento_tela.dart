import 'package:agendacabelo/Controle/funcionamento_controle.dart';
import 'package:agendacabelo/Dados/funcionamento.dart';
import 'package:agendacabelo/Telas/dia_funcionamento_tela.dart';
import 'package:agendacabelo/Telas/editar_horario_funcionamento.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
        title: Text('Horário de funcionamento'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(FontAwesome.ellipsis_v),
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
                  onPressed: () {},
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data.documents.length == 0) {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                  var listaDocuments = snapshot.data.documents;
                  listaDocuments.sort((a, b) =>
                      Util.ordenarDiasSemana(a.documentID)
                          .compareTo(Util.ordenarDiasSemana(b.documentID)));
                  var listaRows = listaDocuments.map((doc) {
                    Funcionamento dados = Funcionamento.fromDocument(doc);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${dados.diaSemana}:",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700)),
                        Text(
                            "${dados.horarioAbertura} - ${dados.horarioFechamento}",
                            style: TextStyle(
                              fontSize: 18,
                            )),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DiaFuncionamentoTela(widget.salao)));
                          },
                          child: Text(
                            "Editar",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Text(
                            "Remover",
                            style: TextStyle(color: Colors.red, fontSize: 18),
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
}
