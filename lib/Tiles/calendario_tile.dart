
import 'package:cortai/Dados/cliente.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Telas/detalhes_cabelereiro_agendado_tela.dart';
import 'package:cortai/Widgets/list_tile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CalendarioTile extends StatefulWidget {
  final Horario horario;
  final Servico servico;
  final bool avaliado;

  final String token;

  CalendarioTile(
      {@required this.horario,
      @required this.servico,
      @required this.token,
      this.avaliado = false});

  @override
  _CalendarioTileState createState() =>
      _CalendarioTileState();
}

class _CalendarioTileState extends State<CalendarioTile>
    with AutomaticKeepAliveClientMixin<CalendarioTile> {
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
    return ListTileCustom(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetalhesCabelereiroTela(
                  horario: widget.horario,
                  servico: widget.servico,
                )));
      },
      title: Container(
        child: Text(
          "Serviço ${widget.servico.descricao}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15.0.sp),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "Dia ${widget.horario.data} às ${widget.horario.hora}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.0.sp),
            ),
          ),
          SizedBox(width: 2.0),
          Container(
              child: Text(
            "Valor: R\$${widget.servico.valor.toStringAsFixed(2)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.0.sp),
          )),
          Container(
            child: Text(
              "Cliente: ${cliente.nome}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.0.sp),
            ),
          ),
        ],
      ),
      // trailing: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Icon(Icons.star, color: Colors.amber, size: 3.0.h),
      //     SizedBox(width: 5.0),
      //     Text(
      //       "4.8",
      //       style: TextStyle(fontSize: 15.0.sp),
      //     ),
      //   ],
      // ),
      leading: null,
    );
  }
}
