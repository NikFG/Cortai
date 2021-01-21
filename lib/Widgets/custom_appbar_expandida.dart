import 'package:cortai/Telas/galeria_tela.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomAppbarExpandida extends StatelessWidget {
  final double appBarHeight = 66.0;
  final double menorValor;
  final double maiorValor;
  final String distancia;
  final String nomeSalao;
  final String enderecoSalao;

  CustomAppbarExpandida(
      {@required this.nomeSalao,
      @required this.enderecoSalao,
      @required this.menorValor,
      @required this.maiorValor,
      @required this.distancia});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        height: statusBarHeight + appBarHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Se quiser adicionar algum item diretamente a parte superior da AppBar utilizar este Widget
            ],
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
            ),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment(0.9, 0.0),
            end: Alignment(0.9, 0.9),
            colors: <Color>[
              Color(0x60000000),
              Color(0x00000000),
            ],
          ),
        ));
  }
}
