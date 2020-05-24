import 'package:agendacabelo/Dados/avaliacao_dados.dart';
import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Util/haversine.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Telas/servico_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeTile extends StatefulWidget {
  final SalaoDados dados;
  final Position currentLocation;

  HomeTile(this.dados, this.currentLocation);

  @override
  _HomeTileState createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  double _media = 0;
  int _quantidade = 0;
  double _menorValor = 0;
  double _maiorValor = 0;
  String _distancia = "";

  @override
  Widget build(BuildContext context) {
    _calculaDistancia();
    _mediaAvaliacoes();
    _minMaxPrecos();
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ServicoTela(
                dados: widget.dados,
                menorValor: _menorValor,
                maiorValor: _maiorValor,
                distancia: _distancia))),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: <Widget>[
              Container(
                height: 100,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: DecorationImage(
                        image: NetworkImage(widget.dados.imagem),
                        fit: BoxFit.contain)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.dados.nome,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _media.toStringAsFixed(1),
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black38),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "(${_quantidade.toString()})",
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black38),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  _distancia,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Entre R\$${_menorValor.toStringAsFixed(2)} ~ R\$${_maiorValor.toStringAsFixed(2)} ",
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black38),
                            ))
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.bottomCenter,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ServicoTela(
                                    dados: widget.dados,
                                    menorValor: _menorValor,
                                    maiorValor: _maiorValor,
                                    distancia: _distancia))),
                      ),
                      ButtonTheme(
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          minWidth: 0,
                          height: 0,
                          child: FlatButton(
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            onPressed: () => _dialogDados(context),
                            child: Text(
                              'Saiba mais',
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).primaryColor),
                            ),
                          )),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _dialogDados(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Mais informações"),
            content: Text("${widget.dados.endereco}"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  Util.LigacaoTelefonica("tel:" + widget.dados.telefone);
                },
                child: Text("Ligar para salão"),
              ),
            ],
          );
        });
  }

  _mediaAvaliacoes() async {
    var lista = await Firestore.instance
        .collection('avaliacoes')
        .where('salao', isEqualTo: widget.dados.id)
        .getDocuments()
        .then((doc) =>
            doc.documents.map((e) => AvaliacaoDados.fromDocument(e)).toList());
    _quantidade = lista.length;
    if (_quantidade > 0) {
      double media = 0;
      for (int i = 0; i < _quantidade; i++) {
        media += lista[i].avaliacao;
      }
      media = media / lista.length;

      _media = media;
      _quantidade = lista.length;
    }
  }

  _minMaxPrecos() async {
    var lista = await Firestore.instance
        .collection('servicos')
        .where('salao', isEqualTo: widget.dados.id)
        .getDocuments()
        .then((doc) =>
            doc.documents.map((e) => PrecoDados.fromDocument(e)).toList());
    lista.sort((a, b) => a.valor.compareTo(b.valor));
    if (lista.length > 0) {
      _menorValor = lista.first.valor;
      _maiorValor = lista.last.valor;
    }
  }

  String _calculaDistancia() {
    double distancia = Haversine.distancia(
        lat1: widget.currentLocation.latitude,
        lon1: widget.currentLocation.longitude,
        lat2: widget.dados.latitude,
        lon2: widget.dados.longitude);

    this._distancia =
        "${(distancia / 1000.0).toStringAsFixed(1)}km".replaceAll(".", ",");
  }
}
