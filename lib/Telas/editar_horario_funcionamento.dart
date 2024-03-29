import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/index_tela.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class EditarFuncionamentoTela extends StatefulWidget {
  EditarFuncionamentoTela();

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
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar/Adicionar Horários'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) => Form(
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
                        onTap: () => _selectTime(context, _aberturaController,
                            'Horário de abertura'),
                        child: AbsorbPointer(
                          child: FormFieldCustom(
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
                          child: FormFieldCustom(
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
                FormFieldCustom(
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
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: deviceInfo.size.height * 15 / 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Column(
                              children: <Widget>[
                                Text(
                                  'DOM',
                                  style: TextStyle(fontSize: 10.0),
                                ),
                                Checkbox(
                                  onChanged: (bool? value) {
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
                                Text('SEG', style: TextStyle(fontSize: 10.0)),
                                Checkbox(
                                  onChanged: (bool? value) {
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
                                Text('TER', style: TextStyle(fontSize: 10.0)),
                                Checkbox(
                                  onChanged: (bool? value) {
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
                                Text('QUA', style: TextStyle(fontSize: 10.0)),
                                Checkbox(
                                  onChanged: (bool? value) {
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
                                Text('QUI', style: TextStyle(fontSize: 10.0)),
                                Checkbox(
                                  onChanged: (bool? value) {
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
                                Text('SEX', style: TextStyle(fontSize: 10.0)),
                                Checkbox(
                                  onChanged: (bool? value) {
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
                                Text('SAB', style: TextStyle(fontSize: 10.0)),
                                Checkbox(
                                  onChanged: (bool? value) {
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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceInfo.size.height * 1 / 10),
                ButtonCustom(
                  textoBotao: "Confirmar",
                  botaoHabilitado: _botaoHabilitado,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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
                          f.salaoId = model.dados!.salaoId!;
                          dados.add(f);
                        }
                      }
                      FuncionamentoControle.updateAll(dados, model.token,
                          onSuccess: onSuccess, onFail: onFail);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context,
      TextEditingController timeController, String helpText) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: TimeOfDay.now(), helpText: helpText);
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
    Navigator.maybeOf(context)!
        .pushReplacement(MaterialPageRoute(builder: (context) => IndexTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Houve um problema ao alterar os horarios")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
