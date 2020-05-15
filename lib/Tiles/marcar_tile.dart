import 'package:agendacabelo/Dados/cabeleireiro_dados.dart';
import 'package:agendacabelo/Dados/funcionamento_dados.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class MarcarTile extends StatefulWidget {
  final CabeleireiroDados dados;

  const MarcarTile(this.dados);

  @override
  _MarcarTileState createState() => _MarcarTileState();
}

class _MarcarTileState extends State<MarcarTile> {
  List diasSemana = [false, false, false, false, false, false, false];
  String _precoAtual;
  String _horarioAtual;
  String _imagemAtual;
  Map<String, String> imagens = Map();
  var _dataController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String _diaSemana;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
          return InkWell(
            onTap: () {},
            child: Card(
              color: Colors.deepOrange[300],
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Cabeleireiro ${widget.dados.nome}"),
                      FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection("servicos")
                              .where("cabeleireiros",
                                  arrayContains: widget.dados.id)
                              .getDocuments(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              return DropdownButton(
                                items: itensPreco(snapshot),
                                onChanged: (value) {
                                  setState(() {
                                    _precoAtual = value;
                                    _imagemAtual = imagens[_precoAtual];
                                  });
                                },
                                isExpanded: false,
                                value: _precoAtual,
                                hint: Text("Serviço"),
                              );
                            }
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 100,
                        height: 10,
                        child: FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection('saloes')
                              .document(widget.dados.salao)
                              .collection('funcionamento')
                              .getDocuments(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              List<FuncionamentoDados> dados =
                                  snapshot.data.documents.map((doc) {
                                return FuncionamentoDados.fromDocument(doc);
                              }).toList();
                              for (int i = 0; i < dados.length; i++) {
                                switch (dados[i].diaSemana) {
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

                              return GestureDetector(
                                onTap: () => _Calendario(context),
                                child: AbsorbPointer(
                                  child: TextField(
                                    decoration:
                                        InputDecoration(hintText: "Data"),
                                    controller: _dataController,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _diaSemana != null
                          ? FutureBuilder(
                              future: Firestore.instance
                                  .collection('saloes')
                                  .document(widget.dados.salao)
                                  .collection('funcionamento')
                                  .document(_diaSemana)
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance
                                        .collection('horarios')
                                        .where('cabeleireiro',
                                            isEqualTo: widget.dados.id)
                                        .where('ocupado', isEqualTo: true)
                                        .where('data',
                                            isEqualTo: _dataController.text)
                                        .snapshots(),
                                    builder: (context, snapshotStream) {
                                      if (!snapshotStream.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        return DropdownButton(
                                          items: itensHorario(
                                              snapshot.data['horarioAbertura'],
                                              snapshot
                                                  .data['horarioFechamento'],
                                              snapshot.data['intervalo'],
                                              snapshotStream),
                                          onChanged: (value) {
                                            setState(() {
                                              _horarioAtual = value;
                                            });
                                          },
                                          isDense: true,
                                          value: _horarioAtual,
                                          hint: Text("Horário"),
                                        );
                                      }
                                    },
                                  );
                                }
                              })
                          : SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                readOnly: true,
                                decoration:
                                    InputDecoration(hintText: "Horários"),
                              ),
                            ),
                      SizedBox(
                        height: 30,
                      ),
                      IconButton(
                        padding: EdgeInsets.only(top: 20),
                        onPressed: () {
                          _adicionarHorario(model.dados['uid']);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeTela()));
                        },
                        icon: Icon(
                          FontAwesome5Solid.check,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return _MostraImagem(
                                _imagemAtual == null ? "" : _imagemAtual);
                          }));
                        },
                        //  child: Hero(
                        //  tag: _imagemAtual == null ? "" : _imagemAtual,
                        child: Image.network(
                          _imagemAtual == null ? "" : _imagemAtual,
                          width: 89,
                          height: 75,
                        ),
                        //    ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<DropdownMenuItem> itensPreco(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      PrecoDados preco = PrecoDados.fromDocument(doc);
      imagens[preco.id] = preco.imagemUrl;
      var tiles = DropdownMenuItem(
        child: Text(
          "${preco.descricao} - R\$${preco.valor.toStringAsFixed(2)}",
        ),
        value: preco.id,
      );
      return tiles;
    }).toList();
  }

  List<DropdownMenuItem> itensHorario(String abertura, String fechamento,
      int intervalo, AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DropdownMenuItem> lista = [];
    DateTime atual = Util.timeFormat.parse(abertura);
    DateTime fecha = Util.timeFormat.parse(fechamento);
    while (atual.isBefore(fecha)) {
      lista.add(DropdownMenuItem(
        child: Text(Util.timeFormat.format(atual)),
        value: Util.timeFormat.format(atual),
      ));
      atual = atual.add(Duration(minutes: intervalo));
    }
    List listaDocuments = snapshot.data.documents.toList();
    if (listaDocuments.length > 0) {
      for (int i = 0; i < listaDocuments.length; i++) {
        int index = lista.indexWhere(
            (element) => element.value == listaDocuments[i].data['horario']);
        if (index != -1) {
          lista.removeAt(index);
        }
      }
    }
    return lista;
  }

  _adicionarHorario(String cliente) async {
    HorarioDados dados = HorarioDados();
    dados.cliente = cliente;
    dados.cabeleireiro = widget.dados.id;
    dados.data = _dataController.text;
    dados.horario = _horarioAtual;
    dados.ocupado = true;
    dados.confirmado = false;
    dados.preco = _precoAtual;
    await Firestore.instance
        .collection("horarios")
        .add(dados.toMap())
        .then((value) async {
      await FlushbarHelper.createSuccess(
              message: "Horário agendado com sucesso")
          .show(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeTela()));
    }).catchError((e) async {
      await FlushbarHelper.createError(
              message: "Ocoreu algum erro ao agendar o horário")
          .show(context);
    });
  }

  Future<Null> _Calendario(BuildContext context) async {
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
    if (picked != null)
      setState(() {
        _diaSemana = Util.weekdayToString(picked);
        _horarioAtual = null;
        selectedDate = picked;
        _dataController.value =
            TextEditingValue(text: Util.dateFormat.format(selectedDate));
      });
  }
}

class _MostraImagem extends StatelessWidget {
  final String _imagemAtual;

  _MostraImagem(this._imagemAtual);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'Foto',
            child: Image.network(_imagemAtual),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
        onPanUpdate: (details) {
          if (details.delta.dx > 10) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
