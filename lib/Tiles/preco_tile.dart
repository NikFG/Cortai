import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:flutter/material.dart';

class PrecoTile extends StatelessWidget {
  final PrecoDados dados;

  PrecoTile(this.dados);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Card(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(8,20,8,0),
                child: Column(

                  children: <Widget>[
                    Text(
                      dados.descricao,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "R\$ ${dados.valor.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
