import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Telas/home_tela.dart';
import 'package:cortai/Widgets/custom_button.dart';
import 'package:cortai/Widgets/custom_form_field.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class EditarFuncionamentoTela extends StatefulWidget {
  final String salao;

  EditarFuncionamentoTela(this.salao);

  @override
  _EditarFuncionamentoTelaState createState() =>
      _EditarFuncionamentoTelaState();
}

class _EditarFuncionamentoTelaState extends State<EditarFuncionamentoTela> {
  //TODO: estilizar
  var _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  var _aberturaController = TextEditingController();
  var _fechamentoController = TextEditingController();
  var _intervaloController = MaskedTextController(mask: '00');
  bool _botaoHabilitado = true;
  List _diasSemana = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar/Adicionar Horários'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: IgnorePointer(
          ignoring: !_botaoHabilitado,
          child: ListView(
            padding: EdgeInsets.all(15),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _selectTime(
                          context, _aberturaController, 'Horário de abertura'),
                      child: AbsorbPointer(
                        child: CustomFormField(
                          controller: _aberturaController,
                          hint: 'Horário de abertura',
                          icon: Icon(Icons.access_time),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Insira o horário de abertura";
                            }
                            return null;
                          },
                          inputType: TextInputType.text,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => _selectTime(context, _fechamentoController,
                          'Horário de fechamento'),
                      child: AbsorbPointer(
                        child: CustomFormField(
                          controller: _fechamentoController,
                          hint: 'Inserir Horário de fechamento',
                          icon: Icon(Icons.access_time),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Insira o horário de fechamento";
                            }
                            return null;
                          },
                          inputType: TextInputType.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomFormField(
                controller: _intervaloController,
                inputType: TextInputType.number,
                hint: "Intervalo entre horários",
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite um número";
                  }
                  if (value == '00' || value == '0') {
                    return 'Não podem haver intervalos menores que 1';
                  }
                  return null;
                },
                icon: Icon(Icons.settings_backup_restore),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 50),
              CustomButton(
                textoBotao: "Confirmar",
                botaoHabilitado: _botaoHabilitado,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _botaoHabilitado = false;
                    });
                    List<Funcionamento> dados = [];
                    for (int i = 0; i < 7; i++) {
                      if (_diasSemana[i]) {
                        Funcionamento f = Funcionamento();
                        f.diaSemana = _diaSemanaIndex(i);
                        f.horarioAbertura = _aberturaController.text;
                        f.horarioFechamento = _fechamentoController.text;
                        f.intervalo = int.parse(_intervaloController.text);
                        dados.add(f);
                      }
                    }
                    FuncionamentoControle.updateAll(dados, widget.salao,
                        onSuccess: onSuccess, onFail: onFail);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context,
      TextEditingController timeController, String helpText) async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: TimeOfDay.now(), helpText: helpText );
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

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Horarios alterados com sucesso")
        .show(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(message: "Horarios alterados com sucesso")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
