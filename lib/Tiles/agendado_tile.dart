import 'package:agendacabelo/Controle/avaliacao_controle.dart';
import 'package:agendacabelo/Dados/avaliacao.dart';
import 'package:agendacabelo/Dados/cabeleireiro.dart';
import 'package:agendacabelo/Dados/horario.dart';
import 'package:agendacabelo/Widgets/custom_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AgendadoTile extends StatefulWidget {
  final Horario horario;

  AgendadoTile(this.horario);

  @override
  _AgendadoTileState createState() => _AgendadoTileState();
}

class _AgendadoTileState extends State<AgendadoTile> {
  double _avaliacao;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: () {
        _detalhesDialog(context);
        /*
        if (widget.horario.confirmado)
          _avaliarDialog(context);
        else
          _cancelarDialog(context);*/
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
            Cabeleireiro dados = Cabeleireiro.fromDocument(snapshot.data);
            return Text("Serviço com ${dados.nome}");
          }
        },
      ),
      subtitle: Text("Dia ${widget.horario.data} às ${widget.horario.horario}"),
      leading: widget.horario.confirmado
          ? Icon(
              Icons.check,
              color: Colors.green,
              size: 48,
            )
          : Icon(
              Icons.clear,
              color: Colors.red,
              size: 48,
            ),
      trailing: FlatButton(
          child: Column(
            children: <Widget>[
              Icon(
                FontAwesome.star_o,
                color: Colors.amberAccent,
              ),
              Text("Avaliar"),
            ],
          ),
          onPressed: () => {_avaliarDialog(context)}),
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

  _detalhesDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Detalhes"),
        content: Container(
//          padding: EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Seu zé Barber",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              Text("Realizado às 12:28 - 16/07/2020",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                  )),
              ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text("Confirmado",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                      ))),
              Text("Agendamento 12",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[500],
                  )),
              ListTile(
                leading: Icon(Icons.looks_one),
                title: Text("Corte Massa",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                    )),
                trailing: Text("R\$19,90",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                    )),
              ),
              Text("Endereço: \n Rua da cobiça 117, Bairro inferno",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  )),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Fechar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Ligar para salão"),
            onPressed: () {
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
