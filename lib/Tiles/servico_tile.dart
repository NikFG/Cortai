import 'package:agendacabelo/Dados/servico_dados.dart';
import 'package:agendacabelo/Telas/agenda_tela.dart';
import 'package:agendacabelo/Telas/forma_pagamento_tela.dart';
import 'package:agendacabelo/Widgets/hero_custom.dart';
import 'package:flutter/material.dart';

class ServicoTile extends StatelessWidget {
  final ServicoDados dados;
  final String imgPadrao =
      "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80";

  ServicoTile(this.dados);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AgendaTela(this.dados))),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HeroCustom(
                          imagemUrl: dados.imagemUrl != null
                              ? dados.imagemUrl
                              : imgPadrao)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.7),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 32,
                    backgroundImage: NetworkImage(
                        dados.imagemUrl != null ? dados.imagemUrl : imgPadrao),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dados.descricao,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "breve descricao",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black87),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            dados.valor.toStringAsFixed(2),
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.bottomCenter,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => AgendaTela(this.dados))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
