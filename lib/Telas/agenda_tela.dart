import 'dart:async';
import 'package:agendacabelo/Controle/cabeleireiro_controle.dart';
import 'package:agendacabelo/Controle/forma_pagamento_controle.dart';
import 'package:agendacabelo/Controle/funcionamento_controle.dart';
import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/cabeleireiro.dart';
import 'package:agendacabelo/Dados/forma_pagamento.dart';
import 'package:agendacabelo/Dados/funcionamento.dart';
import 'package:agendacabelo/Dados/horario.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Widgets/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home_tela.dart';

class AgendaTela extends StatefulWidget {
  final Servico servicoDados;
  final String nomeSalao;

  AgendaTela(this.servicoDados, this.nomeSalao);

  @override
  _AgendaTelaState createState() => _AgendaTelaState();
}

class _AgendaTelaState extends State<AgendaTela> {
  var dataController = TextEditingController();
  var horarioController = TextEditingController();
  var profissionalController = TextEditingController();
  var pagamentoController = TextEditingController();
  String profissional;
  String pagamento;
  DateTime data;
  bool _botaoHabilitado = true;
  var _formKey = GlobalKey<FormState>();
  StreamSubscription<QuerySnapshot> listener;
  int indexPagamento;
  final List<Icon> listaIcons = [
    Icon(FontAwesome.credit_card),
    Icon(FontAwesome.credit_card_alt),
    Icon(FontAwesome.money),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.nomeSalao),
          centerTitle: true,
          leading: Util.leadingScaffold(context)),
      body: Form(
        key: _formKey,
        child: IgnorePointer(
          ignoring: !_botaoHabilitado,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  widget.servicoDados.descricao,
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text(
                    'R\$${widget.servicoDados.valor.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16)),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.servicoDados.imagemUrl != null
                      ? NetworkImage(widget.servicoDados.imagemUrl)
                      : null, //definir imagem padrão
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
                              .map((doc) => Cabeleireiro.fromDocument(doc))
                              .toList();
                          _profissionalBottomSheet(context, cabeleireiros);
                        },
                        child: AbsorbPointer(
                          child: CustomFormField(
                            hint: 'Selecione o Profissional',
                            icon: Icon(Icons.content_cut),
                            controller: profissionalController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Selecione o profissional";
                              }
                              return null;
                            },
                            inputType: TextInputType.text,
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
                          List<Funcionamento> funcionamento = snapshots
                              .documents
                              .map((doc) => Funcionamento.fromDocument(doc))
                              .toList();
                          var diasSemana = _verificaDiasSemana(funcionamento);
                          _calendario(context, diasSemana);
                        },
                        child: AbsorbPointer(
                          child: CustomFormField(
                            icon: Icon(FontAwesome.calendar),
                            hint: 'Selecione a data',
                            controller: dataController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Selecione a data";
                              }
                              return null;
                            },
                            inputType: TextInputType.datetime,
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
                            Funcionamento funcionamento =
                                Funcionamento.fromDocument(snapshot);

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
                          child: CustomFormField(
                            icon: Icon(Icons.access_time),
                            hint: 'Selecione o horário',
                            controller: horarioController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Selecione o horário";
                              }
                              return null;
                            },
                            inputType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Como você gostaria de pagar?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: GestureDetector(
                        onTap: () async {
                          _metodoPagamentoBottomSheet(context);
                        },
                        child: AbsorbPointer(
                          child: CustomFormField(
                            icon: pagamento == null
                                ? null
                                : listaIcons[indexPagamento],
                            hint: 'Selecione o método de pagamento',
                            controller: pagamentoController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Selecione o método de pagamento";
                              }
                              return null;
                            },
                            inputType: TextInputType.text,
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
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 45,
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
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

                    /*
                    Container(
                      height: 100,
                      child: CustomRadio(idPagamento: (value) {
                        this.pagamento = value;
                      }),
                    ),*/

                    Container(
                        alignment: Alignment.topRight,
                        width: MediaQuery.of(context).size.width - 20,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor),
                        child: ScopedModelDescendant<LoginModelo>(
                          builder: (context, child, model) {
                            return FlatButton(
                              onPressed: _botaoHabilitado
                                  ? () async {
                                      if (_formKey.currentState.validate()) {
                                        await listener.cancel();
                                        setState(() {
                                          _botaoHabilitado = false;
                                        });

                                        HorarioControle.get()
                                            .where('cabeleireiro',
                                                isEqualTo: profissional)
                                            .where('data',
                                                isEqualTo: dataController.text)
                                            .where('horario',
                                                isEqualTo:
                                                    horarioController.text)
                                            .getDocuments()
                                            .then((value) {
                                          if (value.documents.length == 0) {
                                            Horario dados = Horario();
                                            dados.cabeleireiro = profissional;
                                            dados.cliente = model.dados.id;
                                            dados.confirmado = false;
                                            dados.data = dataController.text;
                                            dados.formaPagamento =
                                                this.pagamento;
                                            dados.horario =
                                                horarioController.text;
                                            dados.pago = false;
                                            dados.servico =
                                                widget.servicoDados.id;
                                            dados.servicoDados = widget.servicoDados;
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
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        )
                                      : CircularProgressIndicator()),
                            );
                          },
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _horarioBottomSheet(context, Funcionamento funcionamento) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
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
                  List<Horario> horarioDados = snapshot.data.documents
                      .map((doc) => Horario.fromDocument(doc))
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

  _profissionalBottomSheet(context, List<Cabeleireiro> cabeleireiros) {
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

  _metodoPagamentoBottomSheet(context) async {
    await showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (bc) {
          return FutureBuilder<QuerySnapshot>(
            future: FormaPagamentoControle.get()
                .orderBy('descricao')
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      FormaPagamento formaPagamento =
                          FormaPagamento.fromDocument(
                              snapshot.data.documents[index]);
                      return ListTile(
                        onTap: () {
                          this.pagamento = formaPagamento.id;
                          indexPagamento = index;
                          pagamentoController.text = formaPagamento.descricao;
                          Navigator.of(context).pop();
                        },
                        leading: listaIcons[index],
                        title: Text(formaPagamento.descricao),
                      );
                    });
              }
            },
          );
        }).then((value) {});
    setState(() {});
  }

  /*
  * Verifica quais didas da semana estão disponíveis para agendamento.
  * Passa os dados para o calendário
  * */
  _verificaDiasSemana(List<Funcionamento> funcionamento) {
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
        //verifica quais dos dias da semana podem estar clicáveis, dado o vetor de dias da semana
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

  /*
  * Cria o vetor de itens de horários disponíveis
  * */
  List<String> _itensHorario(
      {@required String abertura,
      @required String fechamento,
      @required int intervalo,
      @required List<Horario> horarios,
      @required DateTime horarioAtual}) {
    DateTime inicial = Util.timeFormat.parse(abertura);
    DateTime atual = Util.timeFormat.parse(abertura);
    DateTime fecha = Util.timeFormat.parse(fechamento);
    List<String> listaHorarios = [];
    while (atual.isBefore(fecha)) {
      //cria com todos horários possíveis
      listaHorarios.add(Util.timeFormat.format(atual));
      atual = atual.add(Duration(minutes: intervalo));
    }
    if (horarioAtual != null)
      while (horarioAtual.isAfter(inicial)) {
        //remove os horários que já existem no dia
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
