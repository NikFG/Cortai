import 'dart:async';

import 'package:agendacabelo/Controle/cabeleireiro_controle.dart';
import 'package:agendacabelo/Controle/funcionamento_controle.dart';
import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/cabeleireiro_dados.dart';
import 'package:agendacabelo/Dados/funcionamento_dados.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Dados/servico_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Widgets/custom_radio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home_tela.dart';

class AgendaTela extends StatefulWidget {
  final ServicoDados servicoDados;
  final String nomeSalao;
  AgendaTela(this.servicoDados, this.nomeSalao);

  @override
  _AgendaTelaState createState() => _AgendaTelaState();
}

class _AgendaTelaState extends State<AgendaTela> {
  var dataController = TextEditingController();
  var horarioController = TextEditingController();
  var profissionalController = TextEditingController();
  String profissional;
  String pagamento;
  DateTime data;
  bool _botaoHabilitado = true;
  var _formKey = GlobalKey<FormState>();
  StreamSubscription<QuerySnapshot> listener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.nomeSalao),
          centerTitle: true,
          leading: Util.leadingScaffold(context)),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                widget.servicoDados.descricao,
                style: TextStyle(fontSize: 22, fontFamily: 'Poppins'),
              ),
              subtitle: Text(
                  'R\$${widget.servicoDados.valor.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins')),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: widget.servicoDados.imagemUrl != null
                    ? NetworkImage(widget.servicoDados.imagemUrl)
                    : null,
                backgroundColor: Colors.transparent,
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
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: GestureDetector(
                      onTap: () async {
                        var profissionais = await CabeleireiroControle.get()
                            .where('uid',
                                whereIn: widget.servicoDados.cabeleireiros)
                            .orderBy('nome')
                            .getDocuments();
                        var cabeleireiros = profissionais.documents
                            .map((doc) => CabeleireiroDados.fromDocument(doc))
                            .toList();
                        _profissionalBottomSheet(context, cabeleireiros);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: profissionalController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Selecione o profissional";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.content_cut),
                            hintText: 'Profissional',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Quando seria melhor para você ?",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: GestureDetector(
                      onTap: () async {
                        var snapshots = await SalaoControle.get()
                            .document(widget.servicoDados.salao)
                            .collection('funcionamento')
                            .getDocuments();
                        List<FuncionamentoDados> funcionamento = snapshots
                            .documents
                            .map((doc) => FuncionamentoDados.fromDocument(doc))
                            .toList();
                        var diasSemana = _verificaDiasSemana(funcionamento);
                        _calendario(context, diasSemana);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: dataController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Selecione o dia";
                            }
                            return null;
                          },
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
                    child: Container(
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
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: GestureDetector(
                      onTap: () async {
                        if (this.data != null) {
                          var snapshot = await FuncionamentoControle.get(
                                  widget.servicoDados.salao)
                              .document(Util.weekdayToString(this.data))
                              .get();
                          FuncionamentoDados funcionamento =
                              FuncionamentoDados.fromDocument(snapshot);

                          _horarioBottomSheet(context, funcionamento);
                        } else {
                          FlushbarHelper.createInformation(
                              message: "Selecione o dia primeiro",
                              duration: Duration(
                                milliseconds: 1500,
                              )).show(context);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: horarioController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Selecione o horário";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.access_time),
                            hintText: 'hh:mm',
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
                    child: Container(
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
                  ),
                  Container(
                    height: 100,
                    child: CustomRadio(idPagamento: (value) {
                      this.pagamento = value;
                    }),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Container(
                          alignment: Alignment.topRight,
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).accentColor),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: ScopedModelDescendant<LoginModelo>(
                              builder: (context, child, model) {
                                return FlatButton(
                                  onPressed: _botaoHabilitado
                                      ? () async {
                                          if (this.pagamento == null) {
                                            FlushbarHelper.createError(
                                                    message:
                                                        "Selecione uma forma de pagamento",
                                                    duration:
                                                        Duration(seconds: 2))
                                                .show(context);
                                          }
                                          if (_formKey.currentState
                                                  .validate() &&
                                              this.pagamento != null) {
                                            await listener.cancel();
                                            setState(() {
                                              _botaoHabilitado = false;
                                            });

                                            HorarioControle.get()
                                                .where('cabeleireiro',
                                                    isEqualTo: profissional)
                                                .where('data',
                                                    isEqualTo:
                                                        dataController.text)
                                                .where('horario',
                                                    isEqualTo:
                                                        horarioController.text)
                                                .getDocuments()
                                                .then((value) {
                                              if (value.documents.length == 0) {
                                                HorarioDados dados =
                                                    HorarioDados();
                                                dados.cabeleireiro =
                                                    profissional;
                                                dados.cliente = model.dados.id;
                                                dados.confirmado = false;
                                                dados.data =
                                                    dataController.text;
                                                dados.formaPagamento =
                                                    this.pagamento;
                                                dados.horario =
                                                    horarioController.text;
                                                dados.pago = false;
                                                dados.servico =
                                                    widget.servicoDados.id;

                                                HorarioControle.store(dados,
                                                    onSuccess: onSuccess,
                                                    onFail: onFail);
                                              } else {
                                                FlushbarHelper.createInformation(
                                                        title: "Nos desculpe",
                                                        message:
                                                            "Houve um agendamento neste horário")
                                                    .show(context);
                                                setState(() {
                                                  _botaoHabilitado = true;
                                                });
                                                horarioController.text = "";
                                              }
                                            });
                                          }
                                        }
                                      : null,
                                  child: Center(
                                      child: _botaoHabilitado
                                          ? Text(
                                              'Confirmar',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            )
                                          : CircularProgressIndicator()),
                                );
                              },
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _horarioBottomSheet(context, FuncionamentoDados funcionamento) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
//          List horarios = _itensHorario("8:00", "18:00", 30, []);
          return StreamBuilder<QuerySnapshot>(
              stream: HorarioControle.get()
                  .where('cabeleireiro', isEqualTo: profissional)
                  .where('data', isEqualTo: dataController.text)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<HorarioDados> horarioDados = snapshot.data.documents
                      .map((doc) => HorarioDados.fromDocument(doc))
                      .toList();
                  DateTime dataAgora = DateTime.now();
                  DateTime horarioAtual;
                  if (data.day == dataAgora.day &&
                      dataAgora.month == data.month &&
                      data.year == dataAgora.year) {
                    horarioAtual = Util.timeFormat
                        .parse("${dataAgora.hour}:${dataAgora.minute}");
                  }
                  List<String> horarios = _itensHorario(
                      abertura: funcionamento.horarioAbertura,
                      fechamento: funcionamento.horarioFechamento,
                      intervalo: funcionamento.intervalo,
                      horarios: horarioDados,
                      horarioAtual: horarioAtual);

                  return Container(
                    child: ListView.builder(
                      itemCount: horarios.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            horarioController.text = horarios[index];
                            listener = listenerHorario();

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
                }
              });
        });
  }

  _profissionalBottomSheet(context, List<CabeleireiroDados> cabeleireiros) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<Widget> listTiles = [];
          for (var c in cabeleireiros) {
            listTiles.add(ListTile(
              onTap: () {
                profissionalController.text = c.nome;
                profissional = c.id;
                Navigator.of(context).pop();
              },
              title: Text(
                c.nome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                ),
              ),
            ));
          }
          var tiles = ListTile.divideTiles(
                  tiles: listTiles, color: Colors.grey[500], context: context)
              .toList();
          return ListView(children: tiles);
        });
  }

  _verificaDiasSemana(List<FuncionamentoDados> funcionamento) {
    List<bool> diasSemana = [false, false, false, false, false, false, false];
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
    return diasSemana;
  }

  Future<Null> _calendario(BuildContext context, List diasSemana) async {
    var dataAgora = DateTime.now();
    while (!diasSemana[dataAgora.weekday - 1]) {
      dataAgora = dataAgora.add(Duration(days: 1));
      if (dataAgora.difference(DateTime.now()) >= Duration(days: 7)) {
        break;
      }
    }
    final DateTime picked = await showDatePicker(
        context: context,
        selectableDayPredicate: (DateTime val) =>
            diasSemana[val.weekday - 1] ? true : false,
        initialDate: dataAgora,
        firstDate: dataAgora,
        lastDate: dataAgora.add(Duration(days: 365)),
        helpText: "SELECIONE A DATA",
        fieldLabelText: "DIGITE A DATA",
        locale: Locale('pt'));

    if (picked != null) {
      setState(() {
        this.data = picked;
      });
      dataController.text = Util.dateFormat.format(picked);
      horarioController.text = '';
    }
  }

  List<String> _itensHorario(
      {@required String abertura,
      @required String fechamento,
      @required int intervalo,
      @required List<HorarioDados> horarios,
      @required DateTime horarioAtual}) {
    DateTime inicial = Util.timeFormat.parse(abertura);
    DateTime atual = Util.timeFormat.parse(abertura);
    DateTime fecha = Util.timeFormat.parse(fechamento);
    List<String> listaHorarios = [];
    while (atual.isBefore(fecha)) {
      listaHorarios.add(Util.timeFormat.format(atual));
      atual = atual.add(Duration(minutes: intervalo));
    }
    if (horarioAtual != null)
      while (horarioAtual.isAfter(inicial)) {
        listaHorarios.remove(Util.timeFormat.format(inicial));
        inicial = inicial.add(Duration(minutes: intervalo));
      }
    if (horarios.length > 0) {
      for (var dado in horarios) {
        listaHorarios.remove(dado.horario);
      }
    }

    return listaHorarios;
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Horário agendado com sucesso",
            duration: Duration(milliseconds: 1500))
        .show(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Houve algum erro ao agendar",
            duration: Duration(milliseconds: 1500))
        .show(context);
  }

  StreamSubscription<QuerySnapshot> listenerHorario() {
    var snapshots = HorarioControle.get()
        .where('cabeleireiro', isEqualTo: profissional)
        .where('data', isEqualTo: dataController.text)
        .where('horario', isEqualTo: horarioController.text)
        .snapshots();
    var listener = snapshots.listen((doc) async {
      print("Escutando");
      if (doc.documentChanges.length > 0) {
        horarioController.text = "";
        await FlushbarHelper.createInformation(
            title: "Nos desculpe",
            message: "Houve um agendamento neste horário",
            duration: Duration(
              milliseconds: 2100,
            )).show(context);
      }
    });
    return listener;
  }
}
