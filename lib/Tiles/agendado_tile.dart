import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cortai/Controle/avaliacao_controle.dart';
import 'package:cortai/Dados/avaliacao.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Telas/detalhes_tela.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:cortai/Widgets/list_tile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class AgendadoTile extends StatefulWidget {
  final Horario horario;
  final Servico servico;
  final bool avaliado;

  final String token;

  AgendadoTile(
      {required this.horario,
      required this.servico,
      required this.token,
      this.avaliado = false});

  @override
  _AgendadoTileState createState() => _AgendadoTileState();
}

class _AgendadoTileState extends State<AgendadoTile>
    with AutomaticKeepAliveClientMixin<AgendadoTile> {
  late double _avaliacao;
  late bool avaliado;

  @override
  void initState() {
    super.initState();
    avaliado = widget.avaliado;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    super.build(context);
    return ListTileCustom(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetalhesTela(
                  horario: widget.horario,
                  servico: widget.servico,
                )));
      },
      title: Text(
          "${widget.servico.descricao} com ${widget.horario.cabeleireiro!.nome}"),
      subtitle: Text("Dia ${widget.horario.data} às ${widget.horario.hora}"),
      trailing: widget.horario.pago!
          ? TextButton(
              child: Column(
                children: <Widget>[
                  FittedBox(
                    child: Icon(
                      FontAwesome.star,
                      color: Colors.amberAccent,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  FittedBox(
                    child: Text("Avaliar", style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
              onPressed: () {
                _avaliarDialog(context, widget.token);
              })
          : confirmado(),
      leading: null,
    );
  }

  _avaliarDialog(BuildContext context, String token) {
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
                            color: Colors.blueGrey,
                          ),
                          full: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: FormFieldCustom(
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
                    TextButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Confirmar"),
                      onPressed: () async {
                        if (_avaliacao > 1) {
                          var dataHora = DateTime.now();
                          Avaliacao dados = Avaliacao();
                          dados.valor = _avaliacao;
                          dados.observacao = _descricaoControlador.text;
                          dados.data = Util.dateFormat.format(dataHora);
                          // dados.hora = Util.timeFormat.format(dataHora);
                          dados.horarioId = widget.horario.id!;
                          await AvaliacaoControle.store(dados,
                              token: token, onSuccess: () {}, onFail: () {});
                          avaliado = true;
                          confirmado = true;
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                )).then((value) {
          if (confirmado == true) {
            onSuccess();
            setState(() {});
          }
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
        widget.horario.confirmado!
            ? Icon(
                FontAwesome5.check_circle,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                FontAwesome5.times_circle,
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
