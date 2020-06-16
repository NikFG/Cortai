import 'package:agendacabelo/Dados/funcionamento_dados.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Util/custom_payment.dart';
import 'package:agendacabelo/Util/custom_profissional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Util/custom_date.dart';
import 'package:agendacabelo/Util/custom_time.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:agendacabelo/Telas/teste_tela.dart';

class AgendaTela extends StatefulWidget {
  @override
  _AgendaTelaState createState() => _AgendaTelaState();
}

class _AgendaTelaState extends State<AgendaTela> {
  List<String> buttonList = [
    "Fernando",
    "Mateus",
    "Ana",
    "Julia",
    "Marcus",
    "Celmo",
  ];

  final format = DateFormat("yyyy-MM-dd");
  List<String> horarioList = ["16:30", "19:30", "10:00", "15:00"];
  bool isSelected;
  var dataController = TextEditingController();
  var horarioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Marcar"),
          centerTitle: true,
          leading: Util.leadingScaffold(context)),
      body: ListView(
        children: <Widget>[
          ListTile(
                      title: Text('Corte Topster',style: TextStyle(fontSize: 22,
                      fontFamily: 'Poppins'),),
                      subtitle: Text('R\$15,00',style: TextStyle(fontSize: 16,
                      fontFamily: 'Poppins')),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          "https://i.pinimg.com/originals/bb/5f/6b/bb5f6b2bed3a6ac41d9ba82fa5d47d36.jpg"),
                      ),
                    ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Selecione o Profissional :",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                CustomProfissional(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "Quando seria melhor para você ?",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: () async {
                      List<bool> diasSemana = [
                        false,
                        false,
                        false,
                        false,
                        false,
                        false,
                        false
                      ];
                      var snapshots = await Firestore.instance
                          .collection('saloes')
                          .document(
                              'yJoxHp864CqIWTORAADm') //estático para pegar depois os dados do firebase
                          .collection('funcionamento')
                          .getDocuments();
                      List<FuncionamentoDados> funcionamento = snapshots
                          .documents
                          .map((doc) => FuncionamentoDados.fromDocument(doc))
                          .toList();
                      _verificaDiasSemana(funcionamento, diasSemana);
                      _calendario(context, diasSemana);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dataController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today),
                          hintText: 'dd/mm/yyyy',
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Qual horario?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: () async {
                      _horarioBottomSheet(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: horarioController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.access_time),
                          hintText: 'xx:yy',
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Você tem um código de desconto?',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 45,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ]),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '7C845AB',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Como você gostaria de pagar?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomPayment(),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Container(
                        alignment: Alignment.topRight,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).accentColor),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: FlatButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => AgendaTela())),
                            child: Center(
                                child: Text(
                              'Confirmar',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            )),
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _horarioBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          HorarioDados a = HorarioDados();
          a.horario = '9:00';
          a.data = '21/01/2020';
          a.pago = false;
          HorarioDados b = HorarioDados();
          b.horario = '10:30';
          b.data = '21/01/2020';
          b.pago = false;
          List horarios = _itensHorario("8:00", "18:00", 30, [a, b]);
          return Container(
            child: ListView.builder(
              itemCount: horarios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    horarioController.text = horarios[index];
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    horarios[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  _verificaDiasSemana(
      List<FuncionamentoDados> funcionamento, List<bool> diasSemana) {
    for (int i = 0; i < funcionamento.length; i++) {
      switch (funcionamento[i].diaSemana) {
        case 'SEG':
          diasSemana[0] = true;
          break;
        case 'TER':
          diasSemana[1] = true;
          break;
        case 'QUA':
          diasSemana[2] = true;
          break;
        case 'QUI':
          diasSemana[3] = true;
          break;
        case 'SEX':
          diasSemana[4] = true;
          break;
        case 'SAB':
          diasSemana[5] = true;
          break;
        case 'DOM':
          diasSemana[6] = true;
          break;
      }
    }
  }

  Future<Null> _calendario(BuildContext context, List diasSemana) async {
    var dataAgora = DateTime.now();
    while (!diasSemana[dataAgora.weekday - 1]) {
      dataAgora = dataAgora.add(Duration(days: 1));
    }
    final DateTime picked = await showDatePicker(
        context: context,
        selectableDayPredicate: (DateTime val) =>
            diasSemana[val.weekday - 1] ? true : false,
        initialDate: dataAgora,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2100),
        locale: Locale('pt'));
    if (picked != null) {
      //Apenas printando para quando tiver campo de texto, atualizar valor
      print(picked);
      // setState(() {
      // diasSemana = Util.weekdayToString(picked);
      // _horarioAtual = null;
      // selectedDate = picked;
      dataController.text = Util.dateFormat.format(picked);
      // });
      //}
    }
  }

  _itensHorario(String abertura, String fechamento, int intervalo,
      List<HorarioDados> dados) {
    DateTime atual = Util.timeFormat.parse(abertura);
    DateTime fecha = Util.timeFormat.parse(fechamento);
    List listaHorarios = [];
    while (atual.isBefore(fecha)) {
      listaHorarios.add(Util.timeFormat.format(atual));
      atual = atual.add(Duration(minutes: intervalo));
    }

    if (dados.length > 0) {
      for (var dado in dados) {
        listaHorarios.remove(dado.horario);
      }
    }

    return listaHorarios;
  }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy");
  final diasSemana;
  BasicDateField(this.diasSemana);
  @override
  Widget build(BuildContext context) {
    var dataAgora = DateTime.now();
    while (!diasSemana[dataAgora.weekday - 1]) {
      dataAgora = dataAgora.add(Duration(days: 1));
    }
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              selectableDayPredicate: (DateTime val) =>
                  diasSemana[val.weekday - 1] ? true : false,
              initialDate: dataAgora,
              firstDate: DateTime.now().subtract(Duration(days: 1)),
              lastDate: DateTime(2100),
              locale: Locale('pt'));
        },
      ),
    ]);
  }
}
