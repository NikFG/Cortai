import 'package:cortai/Controle/avaliacao_controle.dart';
import 'package:cortai/Dados/avaliacao.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Telas/detalhes_tela.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/custom_form_field.dart';
import 'package:cortai/Widgets/custom_list_tile.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AgendadoTile extends StatefulWidget {
  final Horario horario;
  final Servico servico;
  final bool avaliado;

  AgendadoTile(
      {@required this.horario,
      @required this.servico,
      this.avaliado});

  @override
  _AgendadoTileState createState() => _AgendadoTileState();
}

class _AgendadoTileState extends State<AgendadoTile>
    with AutomaticKeepAliveClientMixin<AgendadoTile> {
  double _avaliacao;
  bool avaliado;

  @override
  void initState() {
    super.initState();
    avaliado = widget.avaliado;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetalhesTela(
                  horario: widget.horario,
                  servico: widget.servico,
                )));
      },
      title:
          Text("${widget.servico.descricao} com ${widget.horario.cabeleireiro.nome}"),
      subtitle: Text("Dia ${widget.horario.data} às ${widget.horario.hora}"),
      trailing: widget.horario.pago
          ? FlatButton(
              child: Column(
                children: <Widget>[
                  Icon(
                    FontAwesome.star_o,
                    color: Colors.amberAccent,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Avaliar"),
                ],
              ),
              onPressed: () {
                _avaliarDialog(context);
              })
          : confirmado(),
      leading: null,
    );
  }

  _avaliarDialog(BuildContext context) {
    bool confirmado = false;
    var _descricaoControlador = TextEditingController();
    try {
      if (!widget.avaliado) {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: Text(
                      "Qual a avaliação que deseja dar ao seu cabeleireiro?"),
                  content: Wrap(
                    children: <Widget>[
                      RatingBar(
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        onRatingUpdate: (double value) {
                          setState(() {
                            _avaliacao = value;
                          });
                        },
                        ratingWidget: RatingWidget(
                          half: Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          ),
                          empty: Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                          full: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CustomFormField(
                          validator: (value) {
                            return null;
                          },
                          hint: "Descrição",
                          controller: _descricaoControlador,
                          icon: null,
                          inputType: TextInputType.text,
                          isFrase: true,
                        ),
                      )
                    ],
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
                          var dataHora = DateTime.now();
                          Avaliacao dados = Avaliacao();
                          dados.cabeleireiro =
                              widget.horario.cabeleireiro.toString();
                          dados.valor = _avaliacao;
                          dados.observacao = _descricaoControlador.text;
                          dados.salaoId = widget.horario.cabeleireiro.salaoId;
                          dados.data = Util.dateFormat.format(dataHora);
                          // dados.hora = Util.timeFormat.format(dataHora);
                          dados.horarioId = widget.horario.id;
                          AvaliacaoControle.store(dados,
                              onSuccess: () {}, onFail: () {});
                          avaliado = true;
                          confirmado = true;
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                )).then((value) {
          if (confirmado == true) onSuccess();
        });
      } else {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text("Você já avaliou este corte"),
                ));
      }
    } catch (e) {
      onFail();
    }
  }

  Widget confirmado() {
    return Column(
      children: <Widget>[
        Text("Confirmado:"),
        widget.horario.confirmado
            ? Icon(
                FontAwesome.check_circle_o,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                FontAwesome.times_circle_o,
                color: Colors.red,
                size: 35,
              ),
      ],
    );
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Avaliação enviada com sucesso!!",
            duration: Duration(milliseconds: 1300))
        .show(context);
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Houve algum erro ao enviar a avaliação!",
            duration: Duration(milliseconds: 1300))
        .show(context);
  }
}
