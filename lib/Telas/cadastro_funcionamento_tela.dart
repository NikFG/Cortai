import 'package:agendacabelo/Dados/funcionamento_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CadastroFuncionamentoTela extends StatefulWidget {
  @override
  _CadastroFuncionamentoTelaState createState() =>
      _CadastroFuncionamentoTelaState();
}

class _CadastroFuncionamentoTelaState extends State<CadastroFuncionamentoTela> {
  var _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  var _aberturaController = TextEditingController();
  var _fechamentoController = TextEditingController();
  var _almocoStartController = TextEditingController();
  var _almocoEndController = TextEditingController();
  List _diasSemana = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
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
                        controller: _fechamentoController,
                        decoration:
                            InputDecoration(hintText: "Horário de fechamento",prefixIcon: Icon(Icons.access_time),),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text('DOM'),
                          Checkbox(
                            onChanged: (bool value) {
                              setState(() {
                                _diasSemana[0] = value;
                              });
                            },
                            value: _diasSemana[0],
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
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          FuncionamentoDados dados = FuncionamentoDados();
                          dados.horarioAbertura = _aberturaController.text;
                          dados.horarioFechamento = _fechamentoController.text;
                          for (int i = 0; i < 7; i++)
                            if (_diasSemana[i])
                              Firestore.instance
                                  .collection('saloes')
                                  .document(model.dados['salao'])
                                  .collection('funcionamento')
                                  .document(_diaSemanaIndex(i))
                                  .setData(dados.toMap(), merge: true)
                                  .then((value) {})
                                  .catchError((e) {
                                print(e);
                              });
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Text(
                        "Confirmar",
                        style: TextStyle(fontSize: 18),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    }
  }
}
