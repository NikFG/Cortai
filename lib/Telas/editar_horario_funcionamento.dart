import 'package:agendacabelo/Controle/funcionamento_controle.dart';
import 'package:agendacabelo/Dados/funcionamento.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Widgets/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class EditarFuncionamentoTela extends StatefulWidget {
  //final String salao;

  // EditarFuncionamentoTela(this.salao);

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
           Padding(
             padding: EdgeInsets.only(bottom:20),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                Text("Segunda-Feira:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 20,
                    ),
                     GestureDetector(
              onTap: () => _selectTime(context, _aberturaController),
              child: AbsorbPointer(
                child: CustomFormField(
                  controller: _aberturaController,
                  hint: 'Mostrar o horario atual de abertura',
                  icon: Icon(Icons.access_time),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "nao obrigatorio";
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
              onTap: () => _selectTime(context, _fechamentoController),
              child: AbsorbPointer(
                child: CustomFormField(
                  controller: _fechamentoController,
                  hint: 'Mostrar o horario atual de fechamento',
                  icon: Icon(Icons.access_time),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "nao obrigatorio";
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
              height: MediaQuery.of(context).size.height / 2,
            ),
            SizedBox(
              height: 44,
              child: RaisedButton(
                onPressed: () {},
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

