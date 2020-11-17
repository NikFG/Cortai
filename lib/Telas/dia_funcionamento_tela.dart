import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Telas/cadastro_funcionamento_tela.dart';
import 'package:cortai/Widgets/custom_button.dart';
import 'package:cortai/Widgets/custom_form_field.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class DiaFuncionamentoTela extends StatefulWidget {
  final String salao;
  final Funcionamento dados;

  DiaFuncionamentoTela(this.dados, this.salao);

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
              SizedBox(height: 50),
              CustomButton(
                textoBotao: "Confirmar",
                botaoHabilitado: _botaoHabilitado,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _botaoHabilitado = false;
                    });
                    Funcionamento f = Funcionamento();
                    f.diaSemana = widget.dados.diaSemana;
                    f.intervalo = int.parse(_intervaloController.text);
                    f.horarioAbertura = _aberturaController.text;
                    f.horarioFechamento = _fechamentoController.text;
                    FuncionamentoControle.update(f, widget.salao,
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => CadastroFuncionamentoTela(widget.salao)));
  }

  void onFail() async {
    await FlushbarHelper.createError(message: "Horarios alterados com sucesso")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
