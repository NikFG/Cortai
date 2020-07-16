import 'package:agendacabelo/Controle/avaliacao_controle.dart';
import 'package:agendacabelo/Dados/avaliacao.dart';
import 'package:agendacabelo/Dados/cabeleireiro.dart';
import 'package:agendacabelo/Dados/horario.dart';
import 'package:agendacabelo/Widgets/custom_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MarcadoTile extends StatefulWidget {
  final Horario horario;

  MarcadoTile(this.horario);

  @override
  _MarcadoTileState createState() => _MarcadoTileState();
}

class _MarcadoTileState extends State<MarcadoTile> {
  double _avaliacao;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: () {

        if (widget.horario.confirmado)
          _avaliarDialog(context);
        else
          _cancelarDialog(context);
      },
      title: FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance
            .collection('usuarios')
            .document(widget.horario.cabeleireiro)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center();
          } else {
            Cabeleireiro dados =
                Cabeleireiro.fromDocument(snapshot.data);
            return Text("Serviço com ${dados.nome}");
          }
        },
      ),
      subtitle: Text("Dia ${widget.horario.data} às ${widget.horario.horario}"),
      leading: widget.horario.confirmado
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

  _avaliarDialog(BuildContext context) async {
    String salao = await getSalao();
    bool avaliado = await AvaliacaoControle.get()
        .where('horario', isEqualTo: widget.horario.id)
        .where('cabeleireiro', isEqualTo: widget.horario.cabeleireiro)
        .where('salao', isEqualTo: salao)
        .getDocuments()
        .then((value) => value.documents.length > 0);
    if (!avaliado) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                    "Qual a avaliação que deseja dar ao seu cabeleireiro?"),
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
                    onPressed: () {
                      if (_avaliacao > 1) {
                        Avaliacao dados = Avaliacao();
                        dados.cabeleireiro = widget.horario.cabeleireiro;
                        dados.avaliacao = _avaliacao;
                        dados.salao = salao;
                        dados.horario = widget.horario.id;
                        AvaliacaoControle.store(dados,
                            onSuccess: onSuccess, onFail: onFail);
                      }
                    },
                  ),
                ],
              ));
    } else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("Você já avaliou este corte"),
              ));
    }
  }

  Future<String> getSalao() async {
    var snapshot = await Firestore.instance
        .collection('usuarios')
        .document(widget.horario.cabeleireiro)
        .get();
    String salao = snapshot.data['salao'];
    return salao;
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Avaliação enviada com sucesso!!",
            duration: Duration(milliseconds: 1300))
        .show(context);
    Navigator.of(context).pop();
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Houve algum erro ao enviar a avaliação!",
            duration: Duration(milliseconds: 1300))
        .show(context);
  }
}
