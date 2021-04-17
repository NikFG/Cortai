import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Telas/cadastro_funcionamento_tela.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class DiaFuncionamentoTela extends StatefulWidget {
  final Funcionamento dados;
  final String token;

  DiaFuncionamentoTela(this.dados, this.token);

  @override
  _DiaFuncionamentoTelaState createState() => _DiaFuncionamentoTelaState();
}

class _DiaFuncionamentoTelaState extends State<DiaFuncionamentoTela> {
  var _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  var _aberturaController = TextEditingController();
  var _fechamentoController = TextEditingController();
  var _intervaloController = MaskedTextController(mask: '00');
  bool _botaoHabilitado = true;

  @override
  void initState() {
    super.initState();
    _aberturaController.text = widget.dados.horarioAbertura;
    _fechamentoController.text = widget.dados.horarioFechamento;
    _intervaloController.text = widget.dados.intervalo.toString();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Dia'),
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
                    Container(
                      padding: EdgeInsets.only(
                          top: deviceInfo.size.height * 2 / 100,
                          left: deviceInfo.size.height * 2 / 100),
                      child: Text(
                        "Horario de Abertura:",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectTime(
                          context, _aberturaController, 'Horário de abertura'),
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
                    Container(
                      padding: EdgeInsets.only(
                          top: deviceInfo.size.height * 2 / 100,
                          left: deviceInfo.size.height * 2 / 100),
                      child: Text(
                        "Horario de Fechamento:",
                        style: TextStyle(fontSize: 15.0),
                      ),
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
              Container(
                padding: EdgeInsets.only(
                    top: deviceInfo.size.height * 2 / 100,
                    left: deviceInfo.size.height * 2 / 100),
                child: Text(
                  "Intervalo entre horários:",
                  style: TextStyle(fontSize: 15.0),
                ),
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
                height: deviceInfo.size.height * 5 / 100,
              ),
              SizedBox(height: 50),
              ButtonCustom(
                textoBotao: "Confirmar",
                botaoHabilitado: _botaoHabilitado,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _botaoHabilitado = false;
                    });
                    Funcionamento f = widget.dados;
                    f.intervalo = int.parse(_intervaloController.text);
                    f.horarioAbertura = _aberturaController.text;
                    f.horarioFechamento = _fechamentoController.text;
                    FuncionamentoControle.update(f, widget.token,
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
    final TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: TimeOfDay.now(), helpText: helpText);
    if (picked != null)
      setState(() {
        timeController.value = TextEditingValue(text: picked.format(context));
      });
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Horarios alterados com sucesso")
        .show(context);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CadastroFuncionamentoTela()));
  }

  void onFail(String error) async {
    await FlushbarHelper.createError(
            title: "Houve um erro ao alterar os horários", message: error)
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
