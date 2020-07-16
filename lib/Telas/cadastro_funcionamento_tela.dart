import 'package:agendacabelo/Controle/funcionamento_controle.dart';
import 'package:agendacabelo/Dados/funcionamento.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

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
  var _aberturaController = TextEditingController();
  var _fechamentoController = TextEditingController();
  var _intervaloController = MaskedTextController(mask: '00');
  bool _switchMarcado = true;
  bool _botaoHabilitado = true;
  List _diasSemana = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horário de funcionamento'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(15),
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
                    Funcionamento dados =
                        Funcionamento.fromDocument(doc);
                    return Row(
                      children: <Widget>[
                        Text(
                            "${dados.diaSemana}: ${dados.horarioAbertura} - ${dados.horarioFechamento}")
                      ],
                    );
                  }).toList();
                  return Column(
                    children: listaRows,
                  );
                }
              },
            ),
            GestureDetector(
              onTap: () => _selectTime(context, _aberturaController),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _aberturaController,
                  decoration: InputDecoration(
                    hintText: "Horário de abertura",
                    prefixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectTime(context, _fechamentoController),
              child: AbsorbPointer(
                child: TextFormField(
                  autofocus: false,
                  controller: _fechamentoController,
                  decoration: InputDecoration(
                    hintText: "Horário de fechamento",
                    prefixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _intervaloController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Intervalo entre horários",
                prefixIcon: Icon(Icons.settings_backup_restore),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Digite um número";
                }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Switch(
                  onChanged: (value) {
                    setState(() {
                      _switchMarcado = value;
                    });
                  },
                  value: _switchMarcado,
                ),
                Text(_switchMarcado ? "Acrescentar" : "Substituir"),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('DOM'),
                    SizedBox(
                      width: 42,
                      height: 49,
                      child: Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            _diasSemana[0] = value;
                          });
                        },
                        value: _diasSemana[0],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('SEG'),
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          _diasSemana[1] = value;
                        });
                      },
                      value: _diasSemana[1],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('TER'),
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          _diasSemana[2] = value;
                        });
                      },
                      value: _diasSemana[2],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('QUA'),
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          _diasSemana[3] = value;
                        });
                      },
                      value: _diasSemana[3],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('QUI'),
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          _diasSemana[4] = value;
                        });
                      },
                      value: _diasSemana[4],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('SEX'),
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          _diasSemana[5] = value;
                        });
                      },
                      value: _diasSemana[5],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('SAB'),
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          _diasSemana[6] = value;
                        });
                      },
                      value: _diasSemana[6],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 44,
              child: RaisedButton(
                onPressed: _botaoHabilitado
                    ? () async {
                        if (_formKey.currentState.validate()) {
                          Funcionamento dados = Funcionamento();
                          dados.horarioAbertura = _aberturaController.text;
                          dados.horarioFechamento = _fechamentoController.text;
                          dados.intervalo =
                              int.parse(_intervaloController.text);
                          if (!_switchMarcado) {
                            await FuncionamentoControle.get(widget.salao)
                                .getDocuments()
                                .then((value) {
                              for (var doc in value.documents) {
                                doc.reference.delete();
                              }
                            });
                          }
                          for (int i = 0; i < 7; i++) {
                            if (_diasSemana[i]) {
                              await FuncionamentoControle.get(widget.salao)
                                  .document(_diaSemanaIndex(i))
                                  .setData(dados.toMap(), merge: true);
                            }
                          }

                          await FlushbarHelper.createSuccess(
                                  message:
                                      "Horário de funcionamento alterado com sucesso",
                                  duration: Duration(milliseconds: 1200))
                              .show(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeTela()));
                        }
                      }
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                child: _botaoHabilitado
                    ? Text(
                        "Confirmar",
                        style: TextStyle(fontSize: 18),
                      )
                    : CircularProgressIndicator(),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectTime(
      BuildContext context, TextEditingController timeController) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null)
      setState(() {
        timeController.value = TextEditingValue(text: picked.format(context));
      });
  }

  String _diaSemanaIndex(int index) {
    switch (index) {
      case 0:
        return 'DOM';
      case 1:
        return 'SEG';
      case 2:
        return 'TER';
      case 3:
        return 'QUA';
      case 4:
        return 'QUI';
      case 5:
        return 'SEX';
      case 6:
        return 'SAB';
      default:
        return '';
    }
  }
}
