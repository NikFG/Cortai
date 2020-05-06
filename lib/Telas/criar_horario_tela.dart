import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home_tela.dart';

class CriarHorarioTela extends StatefulWidget {
  @override
  _CriarHorarioTelaState createState() => _CriarHorarioTelaState();
}

class _CriarHorarioTelaState extends State<CriarHorarioTela> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _timeController2 = TextEditingController();
  TextEditingController _intevaloController = TextEditingController();
  int _diaDaSemana;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();

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
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      //  keyboardType: TextInputType.datetime,
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
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _timeController,
                      //  keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'Horário inicial agendamento',
                        prefixIcon: Icon(
                          Icons.access_time,
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
                GestureDetector(
                  onTap: () => _selectTime2(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _timeController2,
                      //  keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'Horário inicial agendamento',
                        prefixIcon: Icon(
                          Icons.access_time,
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
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _intevaloController,
                  decoration: InputDecoration(
                    hintText: 'Intervalo',
                  ),
                  // ignore: missing_return
                  validator: (value) {
                    if (int.parse(value) <= 0 && int.parse(value) >= 60) {
                      return "O intervalo deve ser entre 1 e 60";
                    }
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                DropdownButton(
                  onChanged: (value) {
                    setState(() {
                      _diaDaSemana = value;
                    });
                  },
                  isExpanded: true,
                  hint: Text("Dia da semana"),
                  value: _diaDaSemana,
                  items: <DropdownMenuItem>[
                    DropdownMenuItem(
                      child: Text("Domingo"),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text("Segunda"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("Terça"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("Quarta"),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text("Quinta"),
                      value: 4,
                    ),
                    DropdownMenuItem(
                      child: Text("Sexta"),
                      value: 5,
                    ),
                    DropdownMenuItem(
                      child: Text("Sábado"),
                      value: 6,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
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
                        List<String> listaHora = _calculaHorario(
                            _timeController.text,
                            _timeController2.text,
                            int.parse(_intevaloController.text));
                        for (int i = 0; i < listaHora.length; i++) {
                          _adicionaHorario(model.dados['uid'], listaHora[i]);
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeTela()));
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        selectableDayPredicate: (DateTime val) =>
            val.weekday == 5 || val.weekday == 6 ? false : true,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2100),
        locale: Locale('pt'));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.value =
            TextEditingValue(text: dateFormat.format(selectedDate));
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _timeController.value =
            TextEditingValue(text: selectedTime.format(context));
      });
  }

  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime2);
    if (picked != null)
      setState(() {
        selectedTime2 = picked;
        _timeController2.value =
            TextEditingValue(text: selectedTime2.format(context));
      });
  }

  void _adicionaHorario(String uid, String hora) {
    HorarioDados dados = HorarioDados();
    dados.horario = hora;
    dados.data = _dateController.text;
    dados.ocupado = false;
    dados.confirmado = false;
    dados.cabelereiro = uid;
    Firestore.instance.collection('horarios').add(dados.toMap());
  }

  List<String> _calculaHorario(
      String horaInicial, String horaFinal, int intervalo) {
    DateFormat format = DateFormat("H:m");
    DateTime dataInicial = format.parse(horaInicial);
    DateTime dataFinal = format.parse(horaFinal);
    List<String> listaHora = [];
    while (dataInicial.isBefore(dataFinal)) {
      listaHora.add(format.format(dataInicial));
      dataInicial = dataInicial.add(Duration(minutes: intervalo));
    }
    return listaHora;
  }
}
