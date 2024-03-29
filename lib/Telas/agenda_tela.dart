import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cortai/Controle/forma_pagamento_controle.dart';
import 'package:cortai/Controle/funcionamento_controle.dart';
import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/forma_pagamento.dart';
import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Stores/agenda_store.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import 'index_tela.dart';

class AgendaTela extends StatefulWidget {
  final Servico servico;
  final String nomeSalao;

  AgendaTela(this.servico, this.nomeSalao);

  @override
  _AgendaTelaState createState() => _AgendaTelaState();
}

class _AgendaTelaState extends State<AgendaTela> {
  var dataController = TextEditingController();
  var horarioController = TextEditingController();
  var profissionalController = TextEditingController();
  var pagamentoController = TextEditingController();
  AgendaStore store = AgendaStore();
  int? pagamento;
  int? cabeleireiroSelecionado;
  DateTime? data;
  bool _botaoHabilitado = true;
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  late int indexPagamento;
  final List<Icon> listaIcons = [
    Icon(FontAwesome.money),
    Icon(FontAwesome.credit_card),
    Icon(FontAwesome.credit_card_alt),
    Icon(FontAwesome5.dollar_sign)
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              title: Text(widget.nomeSalao),
              centerTitle: true,
              leading: Util.leadingScaffold(context)),
          body: Form(
            key: _formKey,
            child: IgnorePointer(
              ignoring: !_botaoHabilitado,
              child: ListView(
                padding:
                    EdgeInsets.only(bottom: deviceInfo.size.height * 2 / 100),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      widget.servico.descricao!,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    subtitle: Text(
                        'R\$${widget.servico.valor.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14.0)),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: widget.servico.imagem != null
                          ? MemoryImage(base64Decode(widget.servico.imagem!))
                          : AssetImage("assets/images/barbearia.png")
                              as ImageProvider,
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
                                  fontSize: 16.0,
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
                              _profissionalBottomSheet(
                                  context, widget.servico.cabeleireirosApi!);
                            },
                            child: AbsorbPointer(
                              child: FormFieldCustom(
                                hint: 'Profissional',
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
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: GestureDetector(
                            onTap: () async {
                              var response = await http.get(
                                  FuncionamentoControle.get(
                                      widget.servico.salaoId!),
                                  headers: Util.token(model.token));

                              List<Funcionamento> funcionamento =
                                  jsonDecode(response.body)
                                      .map<Funcionamento>(
                                          (f) => Funcionamento.fromJson(f))
                                      .toList();
                              var diasSemana =
                                  _verificaDiasSemana(funcionamento);
                              await _calendario(context, diasSemana);
                            },
                            child: AbsorbPointer(
                              child: FormFieldCustom(
                                icon: Icon(FontAwesome.calendar),
                                hint: 'Data',
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
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: Observer(builder: (context) {
                            if (store.isEmpty &&
                                cabeleireiroSelecionado != null) {
                              store.firePusher(
                                  cabeleireiroSelecionado!, model.token);
                            }
                            return GestureDetector(
                              onTap: () async {
                                if (this.data != null) {
                                  var response = await http.get(
                                      FuncionamentoControle.getDiaSemana(
                                          Util.weekdayToString(data!),
                                          widget.servico.salaoId!),
                                      headers: Util.token(model.token));
                                  Funcionamento funcionamento =
                                      Funcionamento.fromJson(
                                          jsonDecode(response.body));
                                  _horarioBottomSheet(
                                      context, funcionamento, model.token);
                                } else {
                                  FlushbarHelper.createInformation(
                                      message: "Selecione o dia primeiro",
                                      duration: Duration(
                                        milliseconds: 1500,
                                      )).show(context);
                                }
                              },
                              child: AbsorbPointer(
                                child: FormFieldCustom(
                                  icon: Icon(Icons.access_time),
                                  hint: 'Horário',
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
                            );
                          }),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Como você gostaria de pagar?',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: GestureDetector(
                            onTap: () async {
                              _metodoPagamentoBottomSheet(context,
                                  widget.servico.salaoId!, model.token);
                            },
                            child: AbsorbPointer(
                              child: FormFieldCustom(
                                icon: pagamento == null
                                    ? Icon(Icons.add)
                                    : listaIcons[indexPagamento],
                                hint: 'Método de pagamento',
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
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
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
                        ButtonCustom(
                            textoBotao: 'Confirmar',
                            botaoHabilitado: _botaoHabilitado,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                store.unbindEvent('AgendaCabeleireiro');
                                setState(() {
                                  _botaoHabilitado = false;
                                });
                                if (!store
                                    .horarioOcupado(horarioController.text)) {
                                  horarioController.text = "";
                                  await FlushbarHelper.createInformation(
                                          message: "Horário ocupado",
                                          duration: Duration(seconds: 2))
                                      .show(context);
                                  setState(() {
                                    _botaoHabilitado = true;
                                  });
                                } else {
                                  Horario horario = Horario();
                                  horario.cabeleireiroId =
                                      cabeleireiroSelecionado;
                                  horario.clienteId = model.dados!.id;
                                  horario.confirmado = false;
                                  horario.data = dataController.text;
                                  horario.formaPagamentoId = pagamento;
                                  horario.hora = horarioController.text;
                                  horario.pago = false;
                                  horario.servicos =
                                      List<Servico>.of([widget.servico]);

                                  await HorarioControle.store(
                                      horario: horario,
                                      token: model.token,
                                      onSuccess: onSuccess,
                                      onFail: onFail);
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _horarioBottomSheet(
      context, Funcionamento funcionamento, String token) async {
    if (store.isEmpty) {
      await store.getData(
          HorarioControle.getData(
              dataController.text, cabeleireiroSelecionado!),
          token);
    }
    await showModalBottomSheet(
      context: context,
      builder: (context) => Observer(
        builder: (context) {
          if (store.isLoading) {
            return CircularProgressIndicator();
          } else {
            DateTime dataAgora = DateTime.now();
            DateTime? horarioAtual;
            if (data!.day == dataAgora.day &&
                dataAgora.month == data!.month &&
                data!.year == dataAgora.year) {
              horarioAtual = Util.timeFormat
                  .parse("${dataAgora.hour}:${dataAgora.minute}");
            }
            store.itensHorario(
                abertura: funcionamento.horarioAbertura,
                fechamento: funcionamento.horarioFechamento,
                intervalo: funcionamento.intervalo,
                horarioAtual: horarioAtual);
            if (store.stream!.data != null) {
              var dados =
                  Map<String, dynamic>.from(json.decode(store.stream!.data));
              List<Horario> streamData = dados['horarios'].map<Horario>((h) {
                return Horario.fromJson(h);
              }).toList();
              store.updateList(streamData);
            }
            return Container(
              child: ListView.builder(
                itemCount: store.horariosTela.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      horarioController.text = store.horariosTela[index];
                      Navigator.of(context).pop();
                    },
                    title: Text(
                      store.horariosTela[index],
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
        },
      ),
    );
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
                cabeleireiroSelecionado = c.id;
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

  _metodoPagamentoBottomSheet(context, int salaoId, String token) async {
    await showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (bc) {
          return FutureBuilder<http.Response>(
            future: Api.get(FormaPagamentoControle.getBySalao(salaoId), token),
            builder: (context, response) {
              if (!response.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<FormaPagamento> pagamentos =
                    jsonDecode(response.data!.body)
                        .map<FormaPagamento>((p) => FormaPagamento.fromJson(p))
                        .toList();
                return ListView.builder(
                    itemCount: pagamentos.length,
                    itemBuilder: (context, index) {
                      FormaPagamento fp = pagamentos[index];
                      return ListTile(
                        onTap: () {
                          this.pagamento = fp.id;
                          indexPagamento = index;
                          pagamentoController.text = fp.descricao;
                          Navigator.of(context).pop();
                        },
                        leading: listaIcons[index],
                        title: Text(fp.descricao),
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
    final DateTime? picked = await showDatePicker(
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

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Horário agendado com sucesso",
            duration: Duration(milliseconds: 1500))
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => IndexTela()));
  }

  void onFail(String error) async {
    await FlushbarHelper.createError(
            message: error, duration: Duration(milliseconds: 1500))
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }

  @override
  void dispose() {
    store.unbindEvent('AgendaCabeleireiro');
    super.dispose();
  }

// StreamSubscription<QuerySnapshot> listenerHorario() {
//   var snapshots = HorarioControle.get()
//       .where('cabeleireiro', isEqualTo: cabeleireiroSelecionado)
//       .where('data', isEqualTo: dataController.text)
//       .where('horario', isEqualTo: horarioController.text)
//       .snapshots();
//   var listener = snapshots.listen((doc) async {
//     if (doc.documentChanges.length > 0) {
//       horarioController.text = "";
//       await FlushbarHelper.createInformation(
//           title: "Nos desculpe",
//           message: "Houve um agendamento neste horário",
//           duration: Duration(
//             milliseconds: 2100,
//           )).show(context);
//     }
//   });
//   return listener;
// }
}
