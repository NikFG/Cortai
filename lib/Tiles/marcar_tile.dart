import 'package:agendacabelo/Dados/cabelereiro_dados.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/home_tela.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MarcarTile extends StatefulWidget {
  final CabelereiroDados dados;

  const MarcarTile(this.dados);

  @override
  _MarcarTileState createState() => _MarcarTileState();
}

class _MarcarTileState extends State<MarcarTile> {
  String _precoAtual;
  String _dispAtual;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
          return InkWell(
            onTap: () {
              adicionarHorario(_dispAtual, _precoAtual, model.dados['uid']);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeTela()));
            },
            child: Card(
              color: Colors.deepOrange[300],
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Cabelereiro ${widget.dados.nome}"),
                      FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection("usuarios")
                              .document(widget.dados.id)
                              .collection("precos")
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
                                  });
                                },
                                isExpanded: false,
                                value: _precoAtual,
                                hint: Text("Serviço"),
                              );
                            }
                          }),
                      FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection("usuarios")
                              .document(widget.dados.id)
                              .collection("horarios")
                              .where("ocupado", isEqualTo: false)
                              .getDocuments(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              return DropdownButton(
                                items: itensDisp(snapshot),
                                onChanged: (value) {
                                  setState(() {
                                    _dispAtual = value;
                                  });
                                },
                                isExpanded: false,
                                value: _dispAtual,
                                hint: Text("Horário"),
                              );
                            }
                          })
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.network(
                        "https://www.wikihow.com/images/f/f0/Do-Goku-Hair-Step-23.jpg",
                        width: 89,
                        height: 75,
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
      var tiles = DropdownMenuItem(
        child: Text(
          "${preco.descricao} - ${preco.valor.toStringAsFixed(2)}",
        ),
        value: preco.id,
      );
      return tiles;
    }).toList();
  }

  List<DropdownMenuItem> itensDisp(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      HorarioDados horario = HorarioDados.fromDocument(doc);
      var tiles = DropdownMenuItem(
        child: Text(
          "${horario.horario}",
        ),
        value: horario.id,
      );
      return tiles;
    }).toList();
  }

  adicionarHorario(
      String horario_id, String preco_id, String usuario_id) async {
    await Firestore.instance
        .collection("usuarios")
        .document(widget.dados.id)
        .collection("horarios")
        .document(horario_id)
        .updateData({
      "preco_id": preco_id,
      "ocupado": true,
      "confirmado": false,
      "cliente": usuario_id,
    });
  }
}
