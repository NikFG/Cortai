import 'package:agendacabelo/Dados/cabelereiro_dados.dart';
import 'package:agendacabelo/Dados/disponibilidade_dados.dart';
import 'package:agendacabelo/Dados/preco_dados.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: () {},
      child: Card(
        color: Colors.deepOrange[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 9, top: 5),
                  child: Text("Cabelereiro ${widget.dados.nome}"),
                ),
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
                        return Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: DropdownButton(
                            items: itensPreco(snapshot),
                            onChanged: (value) {
                              setState(() {
                                _precoAtual = value;
                              });
                            },
                            isExpanded: false,
                            value: _precoAtual,
                            hint: Text("Preço"),
                          ),
                        );
                      }
                    }),
                FutureBuilder<QuerySnapshot>(
                    future: Firestore.instance
                        .collection("usuarios")
                        .document(widget.dados.id)
                        .collection("disponibilidade")
                        .getDocuments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return Padding(
                          padding: EdgeInsets.zero,
                          child: DropdownButton(
                            items: itensDisp(snapshot),
                            onChanged: (value) {
                              setState(() {
                                _dispAtual = value;
                              });
                            },
                            isExpanded: false,
                            value: _dispAtual,
                            hint: Text("Serviço"),
                          ),
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
                  width: 100,
                  height: 75,
                ),
              ),
            ),
          ],
        ),
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
      DisponibilidadeDados disp = DisponibilidadeDados.fromDocument(doc);
      var tiles = DropdownMenuItem(
        child: Text(
          "${disp.horario}",
        ),
        value: disp.id,
      );
      return tiles;
    }).toList();
  }
}
