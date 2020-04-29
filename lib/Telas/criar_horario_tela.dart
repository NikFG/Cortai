import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

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
                        _calculaHorario(
                            int.parse(_timeController.text.substring(0, 2)),
                            int.parse(_timeController2.text.substring(0, 2)),
                            int.parse(_intevaloController.text),
                            model.dados['uid'],
                            int.parse(_timeController.text.substring(3, 5)),
                            int.parse(_timeController2.text.substring(3, 5)));

//                           _adicionaHorario(model.dados['uid'], 30);
//                        Navigator.of(context).push(MaterialPageRoute(
//                            builder: (context) => HomeTela()));
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

  void _adicionaHorario(String uid, String hora, List minutos) {
    print(minutos);
    for (int i = 0; i < minutos.length; i++) {
      HorarioDados dados = HorarioDados();
      dados.horario = "$hora:${minutos[i]}";
      dados.data = _dateController.text;
      dados.ocupado = false;
      dados.confirmado = false;
      print(dados.toMap());
//      Firestore.instance
//          .collection("usuarios")
//          .document(uid)
//          .collection('horarios')
//          .add(dados.toMap());
    }
  }

  _calculaHorario(int horaInicial, int horaFinal, int intervalo, String uid,
      int minInicial, int minFinal) {
    Map<int, List> mapHorarios = Map();

    for (int i = horaInicial; i <= horaFinal; i++) {
      if (minFinal == 0 && i == horaFinal) {
        break;
      }
      List minutos = [];
      for (int j = minInicial; j < 60; j += intervalo) {
        if (j == 0) {
          minutos.add("00");
        } else {
          minutos.add(j.toString());
        }
        minInicial = j;
      }
      mapHorarios[i] = minutos;
      if (minInicial + intervalo >= 60) {
        minInicial = minInicial + intervalo - 60;
      }
    }

    for (int i = 0; i < horaFinal - horaInicial; i++) {
      _adicionaHorario(uid, mapHorarios.keys.toList()[i].toString(),
          mapHorarios.values.toList()[i]);
    }
  }
}
