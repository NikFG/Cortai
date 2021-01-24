import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Dados/cliente.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Telas/detalhes_tela.dart';
import 'package:cortai/Widgets/custom_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CabelereiroAgendadoTile extends StatefulWidget {
  final Horario horario;
  final Servico servico;
  final bool avaliado;

  final String token;

  CabelereiroAgendadoTile(
      {@required this.horario,
      @required this.servico,
      @required this.token,
      this.avaliado = false});

  @override
  _CabelereiroAgendadoTileState createState() =>
      _CabelereiroAgendadoTileState();
}

class _CabelereiroAgendadoTileState extends State<CabelereiroAgendadoTile>
    with AutomaticKeepAliveClientMixin<CabelereiroAgendadoTile> {
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
    Cliente cliente = widget.horario.cliente;

    super.build(context);
    return CustomListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetalhesTela(
                  horario: widget.horario,
                  servico: widget.servico,
                )));
      },
      title: Container(
        child: Text("${widget.servico.descricao} feito(a) em ${cliente.nome}"),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "Dia ${widget.horario.data} às ${widget.horario.hora}",
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          SizedBox(width: 2.0),
          Container(
              child: Text(
            "Valor :R\$${widget.servico.valor}",
            style: TextStyle(fontSize: 15),
          )),
          Container(
            child: Text(
              "Realizado por : ${widget.servico.id}",
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star, color: Colors.amber, size: 3.0.h),
          SizedBox(width: 5.0),
          Text(
            "4.8",
            style: TextStyle(fontSize: 15.0),
          ),
        ],
      ),
      leading: null,
    );
  }
}
