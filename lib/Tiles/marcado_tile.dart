import 'package:agendacabelo/Dados/avaliacao_dados.dart';
import 'package:agendacabelo/Dados/cabelereiro_dados.dart';
import 'package:agendacabelo/Dados/horario_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MarcadoTile extends StatefulWidget {
  final DocumentSnapshot snapshot;

  MarcadoTile(this.snapshot);

  @override
  _MarcadoTileState createState() => _MarcadoTileState();
}

class _MarcadoTileState extends State<MarcadoTile> {
  double _avaliacao;
  HorarioDados horario;

  @override
  Widget build(BuildContext context) {
    horario = HorarioDados.fromDocument(widget.snapshot);
    return ListTile(
      onTap: () {
        // _cancelarDialog(context);
        _avaliarDialog(context);
      },
      title: FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance
            .collection('usuarios')
            .document(horario.cabelereiro)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            CabelereiroDados dados =
                CabelereiroDados.fromDocument(snapshot.data);
            return Text(dados.nome);
          }
        },
      ),
      subtitle: Text(horario.horario),
      leading: horario.confirmado
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : Icon(
              Icons.clear,
              color: Colors.red,
            ),
    );
  }

  _cancelarDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Deseja mesmo cancelar este agendamento?"),
        content: Text(
            "Caso cancele o agendamento, poderão ser cobradas taxas extras"),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Confirmar"),
            onPressed: () {
              print("CANCELEI HAHA 20MIL PRA EUU");
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _avaliarDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title:
                  Text("Qual a avaliação que deseja dar ao seu cabelereiro?"),
              content: RatingBar(
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (double value) {
                  setState(() {
                    _avaliacao = value;
                  });
                },
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Confirmar"),
                  onPressed: () async {
                    if (_avaliacao > 1) {
                      AvaliacaoDados dados = AvaliacaoDados();
                      dados.cabelereiro = horario.cabelereiro;
                      dados.avaliacao = _avaliacao;
                      dados.salao = await getSalao();
                      await Firestore.instance
                          .collection('avaliacoes')
                          .add(dados.toMap())
                          .then((value) async {
                        await FlushbarHelper.createSuccess(
                                message: "Avaliação enviada com sucesso!!",
                                duration: Duration(milliseconds: 1300))
                            .show(context);
                        Navigator.of(context).pop();
                      });
                    }
                  },
                ),
              ],
            ));
  }

  Future<String> getSalao() async {
    var snapshot = await Firestore.instance
        .collection('usuarios')
        .document(horario.cabelereiro)
        .get();
    String salao = snapshot.data['salao'];
    return salao;
  }
}
