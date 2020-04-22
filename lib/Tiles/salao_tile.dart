import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Telas/marcar_tela.dart';
import 'package:flutter/material.dart';

class SalaoTile extends StatelessWidget {
  final SalaoDados salao;

  SalaoTile(this.salao);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MarcarTela(this.salao.id)));
        },
        child: Card(
          color: Colors.deepOrange[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[Icon(Icons.star), Text("5,0")],
                    ),
                    Text(
                      "Entre R\$15 e R\$100",
                      style: TextStyle(fontSize: 20, color: Colors.black45),
                    ),
                    Divider(),
                    Text(salao.nome,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Divider(
                      height: 2.5,
                    ),
                    FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        createAlertDialog(context);
                      },
                      child: Row(
                        children: <Widget>[
                          Text("Saiba mais"),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Image.network(
                    "https://i.pinimg.com/originals/bb/5f/6b/bb5f6b2bed3a6ac41d9ba82fa5d47d36.jpg",
                    height: 100,
                    width: 75,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Mais informações"),
            content: Text(salao.endereco),
          );
        });
  }
}
