import 'package:agendacabelo/Dados/disponibilidade_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/util.dart';

class CriarHorarioTela extends StatefulWidget {
  @override
  _CriarHorarioTelaState createState() => _CriarHorarioTelaState();
}

class _CriarHorarioTelaState extends State<CriarHorarioTela> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateTime = TextEditingController();
  DateFormat format = DateFormat('E, dd/MM/yyyy H:m', 'pt_BR');
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                GestureDetector(
                  onTap: () => _selectDateTime(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateTime,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'Data agendamento',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                        ),
                      ),
                      // ignore: missing_return
                      validator: (text) {
                        if (text.isEmpty || text == null) {
                          return "INFORME OS DADOS";
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                    height: 44,
                    child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(fontSize: 18),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          DisponibilidadeDados dados = DisponibilidadeDados();
                          dados.horario = _dateTime.text;
                          dados.ocupado = false;
                          dados.confirmado = false;
                          Firestore.instance
                              .collection("usuarios")
                              .document(model.dados['uid'])
                              .collection('disponibilidade')
                              .add(dados.toMap());
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeTela()));
                        }
                      },
                    ))
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectDateTime(BuildContext context) async {
    await _selectDate(context);
    await _selectTime(context);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
        ),
        lastDate: DateTime(2100),
        locale: Locale('pt'));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateTime.value = TextEditingValue(text: picked.toString());
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null)
      setState(() {
        selectedTime = picked;
        selectedDate = Util.DateTimeofDayToDateTime(selectedDate, selectedTime);
        _dateTime.value = TextEditingValue(text: format.format(selectedDate));
      });
  }
}
